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

void main (string[] args) {
    set_log_level_by_args (ref args);

    Gtk.init (ref args);
    var app = new CPUInfo.App ();

    app.run (args);
    Sensors.cleanup();
}

/* ChipName table

Name                              Hardware
--------------------------------------------
coretemp                          Intel CPU
k10temp,k8temp,fam15h_power       AMD CPU
*/

public class CPUInfo.App : Granite.Application {

    private CPUInfo.Core.SensorsEngine engine;
    construct {
        build_data_dir = Build.DATADIR;
        build_pkg_data_dir = Build.PKG_DATADIR;
        build_release_name = Build.RELEASE_NAME;
        build_version = Build.VERSION;
        build_version_info = Build.VERSION_INFO;

        program_name = "CPUInfo";
        exec_name = "cpuinfo";

        app_copyright = "2016";
        application_id = "org.dreamdev.cpuinfo";
        app_icon = "cpuinfo";
        app_launcher = "CPUInfo.desktop";
        app_years = "2016";

        main_url = "https://launchpad.net/cpuinfo";
        bug_url = "https://github.com/DreamDevel/CPUInfo/issues";
        translate_url = "https://translations.launchpad.net/cpuinfo";
        about_authors = {"George Sofianos <georgesofianosgr@gmail.com>",null};
        help_url = "https://answers.launchpad.net/cpuinfo";
        about_artists = {"George Sofianos <georgesofianosgr@gmail.com>", null};
        about_documenters = { "George Sofianos <georgesofianosgr@gmail.com>",
                                      null };
        about_license_type = Gtk.License.GPL_3_0;

        this.set_flags (ApplicationFlags.FLAGS_NONE);
    }

    public Gtk.Window window {get;private set;default = null;}

    public App () {
        engine = new CPUInfo.Core.SensorsEngine();
    }

    public override void activate () {
        if (window == null) {
            initialize();
        }
    }

    private void initialize () {
        window = new Gtk.Window();
        window.width_request = 300;
        window.height_request = 200;
        window.set_default_size(200,300);

        engine.initialize();
        add_window(window);
        window.show();
        var entry = Unity.LauncherEntry.get_for_desktop_file(app_launcher);
        entry.count = 0;
        entry.count_visible = true;

        entry.progress = 0;
        entry.progress_visible = true;

        engine.cpu_details_updated.connect(handle_cpu_details_updated);
    }

    private void handle_cpu_details_updated (CPUInfo.Models.CPU CPU) {
        var entry = Unity.LauncherEntry.get_for_desktop_file(app_launcher);
        entry.count = CPU.temperature;
        entry.progress = CPU.usage / 100.0;
    }
}


void set_log_level_by_args (ref unowned string[] args) {
    foreach (var arg in args) {
        if (arg == "--debug")
            Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;
    }
}
