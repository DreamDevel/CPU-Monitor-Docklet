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

class CPUMonitor.Models.CPU {
    public string manufacturer {get;set;}
    public int temperature {get;set;}
    public int[] core_temperature {get;set;}
    public double usage {get;set;}

    public unowned Sensors.ChipName? chip {get;set;}
    public Sensors.Feature[] features {get;set;}
    public int features_count {get;set;}

    public long total_jiffies {get;set; default = 0;}
    public long idle_jiffies {get;set; default = 0;}


    public CPU () {
        core_temperature = new int[16];
    }
}
