
<p align="center">
<img src="https://www.cyclonis.com/images/2018/07/WPA3-765x437.png" width="200">
</p>

Here are several utilities that came handy during real-world **WPA2** penetration testing assignments centered round great [eaphammer](https://github.com/s0lst1c3/eaphammer.git) tool.

- **`config.txt`** - example of configuraion file for `Death.sh` script.

- **`ServerDHCP.sh`** - This script set's up a DHCP server for Rouge AP / Evil Twin attack purposes, to make the victim actually reach out to the WAN. Nothing fancy, just set of needed commands. Especially handy when used with `Run.sh` script.

- **`Death.sh`** - Simple script intended to perform mass-deathentication of any associated & authenticated client to the Access-Point. Helpful to actively speed up Rogue AP/Evil Twin attacks in multiple Access-Points within an ESSID environments. In other words, if you have an ESSID set up from many access-points (BSSIDs) - this script will help you deauthenitcate all clients from those APs iteratively.

- **`Run.sh`** - This script launches [eaphammer](https://github.com/s0lst1c3/eaphammer.git) tool by s0lst1c3. The tool is a great way to manage hostapd-wpe server as well as perform additional attacks around the concept. Although when used in penetration testing assignments, the tool may not be as reliable as believed due to various nuances with WLAN interface being blocked, not reloaded, DHCP-forced and so on. This is where this script comes in - it tries to automatize those steps before launching the tool and after. Especially handy when used with companion script called: `ServerDHCP.sh`.

<p align="center">
    <a href="https://yassertahiri.medium.com/">
    <img alt="Medium" src="https://img.shields.io/badge/Medium%20-%23000000.svg?&style=for-the-badge&logo=Medium&logoColor=white"/></a>
    <a href="https://twitter.com/THyasser1">
    <img alt="Twitter" src="https://img.shields.io/badge/Twitter%20-%231DA1F2.svg?&style=for-the-badge&logo=Twitter&logoColor=white"</a>
    <a href="https://discord.gg/crNvkTYPYG">
    <img alt="Discord" src="https://img.shields.io/badge/Discord%20-%237289DA.svg?&style=for-the-badge&logo=discord&logoColor=white"/></a>
</p>
