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

public class CPUMonitor.Application : Dream.DockApplication {
    private bool initialized = false;
    private CPUMonitor.Core.SensorsEngine engine;

    construct {
        build_data_dir = Build.DATADIR;
        build_pkg_data_dir = Build.PKG_DATADIR;
        build_release_name = Build.RELEASE_NAME;
        build_version = Build.VERSION;
        build_version_info = Build.VERSION_INFO;

        program_name = "CPU Monitor Docklet";
        exec_name = "cpu-monitor-docklet";

        app_copyright = "2016";
        application_id = "com.dreamdevel.cpu-monitor-docklet";
        app_icon = "cpuinfo";
        app_launcher = "com.dreamdevel.cpu-monitor-docklet.desktop";
        app_years = "2016";

        main_url = "https://launchpad.net/cpu-monitor-docklet";
        bug_url = "https://github.com/DreamDevel/cpu-monitor-docklet/issues";
        translate_url = "https://translations.launchpad.net/cpu-monitor-docklet";
        about_authors = {"George Sofianos <georgesofianosgr@gmail.com>",null};
        help_url = "https://answers.launchpad.net/cpumonitor-docklet";
        about_artists = {"George Sofianos <georgesofianosgr@gmail.com>", null};
        about_documenters = { "George Sofianos <georgesofianosgr@gmail.com>",
                                      null };
        about_license_type = Gtk.License.GPL_3_0;

        this.set_flags (ApplicationFlags.FLAGS_NONE);
    }

    public Application () {
        engine = new CPUMonitor.Core.SensorsEngine();
    }

    public override void activate () {
        base.activate ();

        if (!initialized) {
            initialize();
        }
    }

    private void initialize () {
        engine.initialize();
        engine.cpu_details_updated.connect(handle_cpu_details_updated);
        initialized = true;
    }

    private void handle_cpu_details_updated (CPUMonitor.Models.CPU CPU) {
        set_badge (CPU.temperature);
        set_progress (CPU.usage / 100.0);
    }

}