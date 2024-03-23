# Use an Ubuntu desktop with VNC and noVNC/web access
FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

# Install dependencies required by Slicer, the missing PulseAudio libraries,
# and dependencies for Qt's xcb plugin including additional recommendations
# Add xdotool for window manipulation
RUN apt-get update && apt-get install -y \
    libglu1-mesa libxrender1 libxt6 libxi6 libsm6 libxrandr2 \
    libpulse-mainloop-glib0 \
    libx11-xcb1 \
    libxcb-shape0 libxcb-xinerama0 libxcb-xinerama0-dev \
    libxcb-icccm4-dev libxcb-image0-dev \
    libqt5widgets5 libqt5network5 libqt5gui5 libqt5core5a libqt5dbus5 \
    xdotool \  
    && rm -rf /var/lib/apt/lists/*

# Copy your pre-downloaded Slicer directory to the container
COPY Slicer /opt/slicer

# Set the necessary environment variables for Slicer
ENV SLICER_HOME=/opt/slicer
ENV PATH="${SLICER_HOME}:$PATH"

# Create a custom script to start Slicer and maximize its window
RUN echo '#!/bin/bash\n\
/opt/slicer/Slicer &\n\
# Wait for the Slicer window to appear\n\
while ! xdotool search --name "3D Slicer" 2>/dev/null; do sleep 1; done\n\
# Maximize the Slicer window. Adjust the search term as necessary.\n\
xdotool search --name "3D Slicer" windowactivate windowsize 100% 100%' > /usr/local/bin/start-slicer-maximized.sh \
    && chmod +x /usr/local/bin/start-slicer-maximized.sh

# Update Supervisor configuration to use the custom script
RUN echo '[program:slicer]' > /etc/supervisor/conf.d/slicer.conf \
    && echo 'command=/usr/local/bin/start-slicer-maximized.sh' >> /etc/supervisor/conf.d/slicer.conf \
    && echo 'environment=DISPLAY=":1.0"' >> /etc/supervisor/conf.d/slicer.conf \
    && echo 'autostart=true' >> /etc/supervisor/conf.d/slicer.conf \
    && echo 'autorestart=true' >> /etc/supervisor/conf.d/slicer.conf \
    && echo 'stderr_logfile=/var/log/slicer.err.log' >> /etc/supervisor/conf.d/slicer.conf \
    && echo 'stdout_logfile=/var/log/slicer.out.log' >> /etc/supervisor/conf.d/slicer.conf
