#!/bin/bash
#
# setalsa-tmv71a.sh
#
# Configuration for a Kenwood TM-V71a attached to Left or Right channel
# on a DRAWS HAT
#
# mDin6 connector on left channel,  direwolf chan 0
# mDin6 connector on right channel, direwolf chan 1
#


MODE_9600_ENABLE=false

asoundstate_file="/var/lib/alsa/asound.state"

SWITCH_FILE="/etc/ax25/packet_9600baud"

if [ -e "$SWITCH_FILE" ] ; then
    MODE_9600_ENABLE=true
fi

stateowner=$(stat -c %U $asoundstate_file)
if [ $? -ne 0 ] ; then
   "Command 'alsactl store' will not work, file: $asoundstate_file does not exist"
   exit
fi

# Be sure we're running as root
 if [[ $EUID != 0 ]] ; then
   echo "Command 'alsactl store' will not work unless you are root"
fi

# IN1 Discriminator output (FM function only, not all radios, 9600 baud packet)
# IN2 Compensated receive audio (all radios, 1200 baud and slower packet)

if [ "$MODE_9600_ENABLE" = "true" ] ; then

    echo "debug: 9600 baud enable ie. DISCOUT"
    # For 9600 baud packet only
    # Turn AFOUT off & DISCOUT on
    # ie. Receive audio off & discriminator input on

    amixer -c udrc -s << EOF
sset 'PCM' 0.0dB,0.0dB
sset 'LO Driver Gain' 3.0dB,3.0dB
sset 'ADC Level' -4.0dB,-4.0dB

sset 'IN1_L to Left Mixer Positive Resistor' '10 kOhm'
sset 'IN1_R to Right Mixer Positive Resistor' '10 kOhm'
sset 'IN2_L to Left Mixer Positive Resistor' 'Off'
sset 'IN2_R to Right Mixer Positive Resistor' 'Off'
EOF

else
    echo "debug: 1200 baud enable ie. AFOUT"
    # Default mode, for HF & 1200 baud packet
    # Turn AFOUT on & DISCOUT off
    # ie. Receive audio on & discriminator off

    amixer -c udrc -s << EOF
sset 'PCM' -2.0dB,-2.0dB
sset 'LO Driver Gain' 0.0dB,0.0dB
sset 'ADC Level' 0.0dB,0.0dB

sset 'IN1_L to Left Mixer Positive Resistor' 'Off'
sset 'IN1_R to Right Mixer Positive Resistor' 'Off'
sset 'IN2_L to Left Mixer Positive Resistor' '10 kOhm'
sset 'IN2_R to Right Mixer Positive Resistor' '10 kOhm'
EOF
fi

amixer -c udrc -s << EOF
# Set default input and output levels
# Everything after this line is common to both audio channels

sset 'CM_L to Left Mixer Negative Resistor' '10 kOhm'
sset 'CM_R to Right Mixer Negative Resistor' '10 kOhm'

#  Turn off unnecessary pins
sset 'IN1_L to Right Mixer Negative Resistor' 'Off'
sset 'IN1_R to Left Mixer Positive Resistor' 'Off'

sset 'IN2_L to Right Mixer Positive Resistor' 'Off'
sset 'IN2_R to Left Mixer Negative Resistor' 'Off'

sset 'IN3_L to Left Mixer Positive Resistor' 'Off'
sset 'IN3_L to Right Mixer Negative Resistor' 'Off'
sset 'IN3_R to Left Mixer Negative Resistor' 'Off'
sset 'IN3_R to Right Mixer Positive Resistor' 'Off'

sset 'Mic PGA' off
sset 'PGA Level' 0

# Disable and clear AGC
sset 'ADCFGA Right Mute' off
sset 'ADCFGA Left Mute' off
sset 'AGC Attack Time' 0
sset 'AGC Decay Time' 0
sset 'AGC Gain Hysteresis' 0
sset 'AGC Hysteresis' 0
sset 'AGC Max PGA' 0
sset 'AGC Noise Debounce' 0
sset 'AGC Noise Threshold' 0
sset 'AGC Signal Debounce' 0
sset 'AGC Target Level' 0
sset 'AGC Left' off
sset 'AGC Right' off

# Turn off High Power output
sset 'HP DAC' off
sset 'HP Driver Gain' 0
sset 'HPL Output Mixer L_DAC' off
sset 'HPR Output Mixer R_DAC' off
sset 'HPL Output Mixer IN1_L' off
sset 'HPR Output Mixer IN1_R' off

#  Turn on the LO DAC
sset 'LO DAC' on

# Turn on both left & right channels
# Turn on AFIN
sset 'LOL Output Mixer L_DAC' on

# Turn on TONEIN
sset 'LOR Output Mixer R_DAC' on
EOF
alsactl store
