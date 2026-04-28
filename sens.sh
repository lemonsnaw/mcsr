
#Usage
# Run the script with no arguments to apply the custom settings:
#   ./sens.sh
# To revert to default settings, run the script with the "revert" argument:
#   ./sens.sh revert
# set to 1 to use maccel for sensitivity multiplier, set to 0 to only change libinput accel speed and profile
USE_MACCEL=1; 

# Default values that system should revert back to normal when script is killed
DEFAULT_MACCEL_SENS_MULTIPLIER=1;
DEFAULT_ACCEL_PROFILE="1 0 0";
DEFAULT_ACCEL_SPEED=0.000000;


# CONFIGURATION - change these values to your liking

CONF_MACCEL_SENS_MULTIPLIER=8;
CONF_LIBINPUT_ACCEL_SPEED=-0.875
CONF_MOUSE_NAME="Wings Tech Gaming Mouse"
#to disble default accel profile , use revert to revert back to default settings
CONF_ACCEL_PROFILE_ENABLED="0 1 0"



# find line with mouse name ingoring anything that has additionals text 
#after MOUSE_NAME to avoid matching weird devices like MOUSE_NAME Keyboard, extract id=NUMBER, then extract NUMBER
MOUSE_ID=$(xinput --list --id-only "Wings Tech Gaming Mouse");

if [[ -z "$MOUSE_ID" ]]; then
  echo "Mouse not found: $MOUSE_NAME" >&2
  exit 1
fi
echo "Found mouse id: $MOUSE_ID"

if [[ "$1" == "revert" ]]; then
    # Revert to default settings
    echo "Reverting to default settings..."
    xinput set-prop "$MOUSE_ID" "libinput Accel Speed" $DEFAULT_ACCEL_SPEED
    xinput set-prop "$MOUSE_ID" "libinput Accel Profile Enabled" $DEFAULT_ACCEL_PROFILE
    
    if [[ $USE_MACCEL -eq 1 && -x "$(command -v maccel)" ]]; then
         maccel set param sens-mult "$DEFAULT_MACCEL_SENS_MULTIPLIER"
    fi
    echo "Settings reverted to default."
    exit 0
fi


# set accel speed for mouse and disable default accel profile
xinput set-prop "$MOUSE_ID" "libinput Accel Speed" $CONF_LIBINPUT_ACCEL_SPEED
xinput set-prop "$MOUSE_ID" "libinput Accel Profile Enabled" $CONF_ACCEL_PROFILE_ENABLED
if [[ $USE_MACCEL -eq 1 && -x "$(command -v maccel)" ]]; then
    maccel set param sens-mult "$CONF_MACCEL_SENS_MULTIPLIER"
fi
echo "Custom settings applied to mouse id: $MOUSE_ID"
