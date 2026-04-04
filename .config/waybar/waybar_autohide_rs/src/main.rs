use gtk::prelude::*;
use gtk::{Application, ApplicationWindow};
use gtk_layer_shell::{Edge, Layer, LayerShell};
use std::process::Command;
use std::rc::Rc;
use std::cell::RefCell;
use std::env;

#[derive(Clone, Copy, PartialEq, Debug)]
enum AppEdge {
    Left,
    Right,
    Top,
    Bottom,
}

struct AppState {
    edge: AppEdge,
    trigger_size: i32,
    bar_size: i32,
    hide_delay_ms: u32,
    bar_visible: bool,
    hide_timer_id: Option<glib::SourceId>,
}

fn toggle_waybar() {
    println!("[DEBUG] Toggling waybar...");
    if let Err(e) = Command::new("killall").args(["-SIGUSR1", "waybar"]).spawn() {
        eprintln!("[ERROR] Failed to send SIGUSR1 to waybar: {}", e);
    }
}

fn reposition_strip(window: &ApplicationWindow, app_edge: AppEdge, margin: i32) {
    let gtk_edge = match app_edge {
        AppEdge::Left => Edge::Left,
        AppEdge::Right => Edge::Right,
        AppEdge::Top => Edge::Top,
        AppEdge::Bottom => Edge::Bottom,
    };
    println!("[DEBUG] Repositioning strip: margin {} on edge {:?}", margin, app_edge);
    window.set_layer_shell_margin(gtk_edge, margin);
}

fn build_ui(app: &Application, state: Rc<RefCell<AppState>>) {
    let window = ApplicationWindow::new(app);
    
    window.init_layer_shell();
    window.set_layer(Layer::Overlay);
    window.set_namespace("waybar-autohide");
    
    // -1 means don't reserve space
    window.set_exclusive_zone(-1);

    let current_state = state.borrow();
    match current_state.edge {
        AppEdge::Left => {
            window.set_anchor(Edge::Left, true);
            window.set_anchor(Edge::Top, true);
            window.set_anchor(Edge::Bottom, true);
            window.set_size_request(current_state.trigger_size, -1);
        }
        AppEdge::Right => {
            window.set_anchor(Edge::Right, true);
            window.set_anchor(Edge::Top, true);
            window.set_anchor(Edge::Bottom, true);
            window.set_size_request(current_state.trigger_size, -1);
        }
        AppEdge::Top => {
            window.set_anchor(Edge::Top, true);
            window.set_anchor(Edge::Left, true);
            window.set_anchor(Edge::Right, true);
            window.set_size_request(-1, current_state.trigger_size);
        }
        AppEdge::Bottom => {
            window.set_anchor(Edge::Bottom, true);
            window.set_anchor(Edge::Left, true);
            window.set_anchor(Edge::Right, true);
            window.set_size_request(-1, current_state.trigger_size);
        }
    }

    reposition_strip(&window, current_state.edge, 0);
    drop(current_state);

    window.set_app_paintable(true);
    if let Some(screen) = gtk::prelude::WidgetExt::screen(&window) {
        if let Some(visual) = screen.rgba_visual() {
            window.set_visual(Some(&visual));
        }
    }

    window.connect_draw(|_, cr| {
        cr.set_source_rgba(0.0, 0.0, 0.0, 0.0); // Fully transparent
        let _ = cr.paint();
        glib::Propagation::Proceed
    });

    let state_clone_enter = state.clone();
    let window_clone_enter = window.clone();
    window.connect_enter_notify_event(move |_, event| {
        let mut s = state_clone_enter.borrow_mut();
        let (x, y) = event.position();
        println!("[DEBUG] Mouse entered trigger zone (at {}, {}). bar_visible={}", x, y, s.bar_visible);
        
        if !s.bar_visible {
            if let Some(id) = s.hide_timer_id.take() {
                id.remove();
            }
            toggle_waybar();
            s.bar_visible = true;
            reposition_strip(&window_clone_enter, s.edge, s.bar_size);
        } else {
            if s.hide_timer_id.is_none() {
                println!("[DEBUG] Starting hide timer ({} ms)", s.hide_delay_ms);
                let state_clone_timer = state_clone_enter.clone();
                let window_clone_timer = window_clone_enter.clone();
                let delay = s.hide_delay_ms;
                
                let id = glib::timeout_add_local(std::time::Duration::from_millis(delay as u64), move || {
                    let mut st = state_clone_timer.borrow_mut();
                    println!("[DEBUG] Hide timer fired.");
                    if st.bar_visible {
                        toggle_waybar();
                        st.bar_visible = false;
                        reposition_strip(&window_clone_timer, st.edge, 0);
                    }
                    st.hide_timer_id = None;
                    glib::ControlFlow::Break
                });
                s.hide_timer_id = Some(id);
            }
        }
        glib::Propagation::Proceed
    });

    let state_clone_leave = state.clone();
    window.connect_leave_notify_event(move |_, event| {
        let mut s = state_clone_leave.borrow_mut();
        if s.bar_visible && s.hide_timer_id.is_some() {
            let (x, y) = event.position();
            let went_back = match s.edge {
                AppEdge::Left => x < 0.0,
                AppEdge::Right => x >= s.trigger_size as f64,
                AppEdge::Top => y < 0.0,
                AppEdge::Bottom => y >= s.trigger_size as f64,
            };
            
            if went_back {
                println!("[DEBUG] Mouse went back to bar, cancelling hide timer.");
                if let Some(id) = s.hide_timer_id.take() {
                    id.remove();
                }
            }
        }
        glib::Propagation::Proceed
    });

    window.add_events(gdk::EventMask::ENTER_NOTIFY_MASK | gdk::EventMask::LEAVE_NOTIFY_MASK);
    window.show_all();
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut initial_state = AppState {
        edge: AppEdge::Left,
        trigger_size: 6,
        bar_size: 36,
        hide_delay_ms: 800,
        bar_visible: false,
        hide_timer_id: None,
    };

    let mut i = 1;
    while i < args.len() {
        if args[i] == "--edge" && i + 1 < args.len() {
            i += 1;
            match args[i].as_str() {
                "left" => initial_state.edge = AppEdge::Left,
                "right" => initial_state.edge = AppEdge::Right,
                "top" => initial_state.edge = AppEdge::Top,
                "bottom" => initial_state.edge = AppEdge::Bottom,
                _ => {}
            }
        } else if args[i] == "--size" && i + 1 < args.len() {
            i += 1;
            if let Ok(val) = args[i].parse() {
                initial_state.trigger_size = val;
            }
        } else if args[i] == "--bar-size" && i + 1 < args.len() {
            i += 1;
            if let Ok(val) = args[i].parse() {
                initial_state.bar_size = val;
            }
        } else if args[i] == "--delay" && i + 1 < args.len() {
            i += 1;
            if let Ok(val) = args[i].parse() {
                initial_state.hide_delay_ms = val;
            }
        }
        i += 1;
    }

    println!("[INFO] Starting waybar-autohide (Rust port)");

    let application = Application::builder()
        .application_id("com.github.waybar-autohide")
        .build();

    let state = Rc::new(RefCell::new(initial_state));
    
    application.connect_activate(move |app| {
        build_ui(app, state.clone());
    });

    application.run_with_args(&Vec::<String>::new());
}
