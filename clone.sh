#!/bin/bash

repos="
       git://git.moblin.org/anerley
       git://git.moblin.org/bickley.git
       git://git.moblin.org/bisho.git
       git://git.moblin.org/bognor-regis.git
       git://cgit.freedesktop.org/ccss/
       git://git.clutter-project.org/clutter.git
       git://git.clutter-project.org/clutter-box2d.git
       git://git.clutter-project.org/clutter-gst.git
       git://git.clutter-project.org/clutter-gtk.git
       git://git.clutter-project.org/clutter-mozembed.git
       git://git.moblin.org/dalston.git
       git://git.moblin.org/hornsey.git
       git://git.gnome.org/jana
       git://git.moblin.org/libccss
       git://git.moblin.org/mozilla-headless-services
       git://git.moblin.org/librest.git
       git://git.moblin.org/moblin-cursor-theme.git
       git://git.moblin.org/moblin-gtk-engine.git
       git://git.moblin.org/moblin-icon-theme.git
       git://git.moblin.org/moblin-menus.git
       git://git.moblin.org/moblin-user-skel.git
       git://git.moblin.org/moblin-web-browser.git
       git://git.moblin.org/mojito.git
       git://git.moblin.org/mutter.git
       git://git.moblin.org/mutter-moblin.git
       git://git.moblin.org/mux.git
       git://git.moblin.org/nbtk.git
       git://github.com/ebassi/twitter-glib.git
"

for git_url in $repos
do
	git clone $git_url 
done

# exception
mv libccss ccss
mv mozilla-headless-services libmhs
