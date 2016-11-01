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

class CPUInfo.Core.SensorsEngine {

    public CPUInfo.Models.CPU CPU {get;set;}
    private int interval {get;set;}

    public signal void cpu_details_updated(CPUInfo.Models.CPU CPU);


    public void initialize(int interval = 200) {
        Sensors.init();
        debug(@"Sensors Version: $(Sensors.version)\n");
        this.interval = interval;

        build_CPU_info ();
        setup_update_details_interval ();

        update_cpu_usage ();
    }

    private void build_CPU_info () {
        CPU = new CPUInfo.Models.CPU();

        int features_count = 0;
        unowned Sensors.ChipName? chip = find_chip ();
        var chip_features = find_chip_features (chip,out features_count);

        if (chip.prefix == "coretemp")
            CPU.manufacturer = "Intel";
        else
            CPU.manufacturer = "AMD";

        CPU.chip = chip;
        CPU.features = chip_features;
        CPU.features_count = features_count;
    }

    /* ChipName table
    Name                              Hardware
    --------------------------------------------
    coretemp                          Intel CPU
    k10temp,k8temp,fam15h_power       AMD CPU
    */
    // TODO fix this to return only intel or AMD
    private unowned Sensors.ChipName? find_chip () {
        unowned Sensors.ChipName? chip = null;
        int nm = 0;
        while(true) {
            chip = Sensors.get_detected_chips(null,ref nm);
            if (chip != null) {
                if (chip.prefix == "coretemp") {
                    debug("Found Intel CPU");
                    break;
                }
            }
            else
                break;
        }

        return chip;
    }

    private Sensors.Feature[] find_chip_features (Sensors.ChipName? chip, out int features_count) {
        var features = new Sensors.Feature[16];
        int features_found = 0;

        int nm = 0;
        while (true) {
            var feature = chip.get_features(ref nm);

            if (feature != null) {
                features[features_found] = feature;
                features_found++;
            }
            else {
                break;
            }
        }

        features_count = features_found;
        return features;
    }

    private void setup_update_details_interval () {
        Timeout.add(interval,update_details);
    }

    private bool update_details () {
        for (var i=0; i < CPU.features_count; i++) {
            var feature = CPU.features[i];
            var label = Sensors.get_label(CPU.chip,feature);
            var subfeature = CPU.chip.get_subfeature(feature,Sensors.SubFeatureType.TEMP_INPUT);
            if (subfeature != null) {
                double val;
                Sensors.get_value(CPU.chip,subfeature.number,out val);

                if (label == "Physical id 0")
                    CPU.temperature = (int) val;
                // TODO Add Core Temperatures
            }
        }

        var cpu_usage = get_cpu_usage_percentage ();
        CPU.usage = cpu_usage;

        cpu_details_updated(CPU);
        return true;
    }

    private double get_cpu_usage_percentage () {
        var prev_total = CPU.total_jiffies;
        var prev_idle  = CPU.idle_jiffies;

        update_cpu_usage ();

        var total_diff = (prev_total - CPU.total_jiffies).abs();
        var idle_diff  = (prev_idle  - CPU.idle_jiffies).abs();
        var percentage = 100 - (100 * idle_diff / total_diff);
        return percentage;
    }


    private void update_cpu_usage () {
        GTop.Cpu cpu;
        GTop.get_cpu (out cpu);

        CPU.total_jiffies = (long)cpu.total;
        CPU.idle_jiffies = (long)cpu.idle;
    }
}
