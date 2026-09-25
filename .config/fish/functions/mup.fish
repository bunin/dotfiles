# Same as omarchy's `mup`: skips mise's default 24h minimum_release_age.
function mup --wraps 'mise upgrade' --description 'mise upgrade, no release-age wait'
    MISE_MINIMUM_RELEASE_AGE=0 mise upgrade $argv
end
