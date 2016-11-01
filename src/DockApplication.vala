/*-
 *  Copyright (c) 2016 George Sofianos
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Authored by: George Sofianos <georgesofianosgr@gmail.com>
 *
 */

public class Dream.DockApplication : Granite.Application {
    private bool initialized = false;

    Unity.LauncherEntry entry;

    public void set_badge(int value) {
        entry.count = value;
    }

    public void set_progress(double value) {
        entry.progress = value;
    }

    public void set_badge_visible (bool value) {
        entry.count_visible = value;
    }

    public void set_progress_visible (bool value) {
        entry.progress_visible = value;
    }

    public DockApplication () {
        entry = Unity.LauncherEntry.get_for_desktop_file(app_launcher);
        set_badge_visible(true);
        set_progress_visible(true);
    }

    public override void activate () {
        if (!initialized) {
            initialize();
            initialized = true;
        }
    }

    private void initialize () {
        hold();
        add_actions();
    }

    private void add_actions () {
        SimpleAction close_action = new SimpleAction ("close", null);
        close_action.activate.connect (handle_close_action);
        this.add_action (close_action);
    }

    private void handle_close_action () {
        debug("Close Action Activated");
        this.hold ();
        quit();
        this.release ();
    }

    public new int run (string[] args) {

        foreach (var arg in args) {
            if (arg == "--close") {
                this.register (null);
                this.activate_action("close",null);
                Process.exit (0);
            }
        }

        return base.run (args);
    }
}