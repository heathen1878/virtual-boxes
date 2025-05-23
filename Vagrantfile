require 'yaml'

config_data = YAML.load_file('vagrant/vagrant_config.yaml')

Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/jammy64"

    bridge_iface = ENV["BRIDGE_IFACE"]
    raise "❌ BRIDGE_IFACE is not set. Use: BRIDGE_IFACE=enp1s0f0 make up" unless bridge_iface && !bridge_iface.empty?

    config_data['nodes'].each do |name, details|
        ip = details['ip']
        raise "❌ IP address for #{name} is not set. Please check vagrant_config.yaml" unless ip && !ip.empty?
        role = details['role']
        raise "❌ Role for #{name} is not set. Please check vagrant_config.yaml" unless role && !role.empty?
        raise "❌ Role #{role} is not supported. Please check vagrant_config.yaml" unless ['master', 'worker'].include?(role)

        config.vm.define name do |node|
            node.vm.hostname = name
            node.vm.boot_timeout = 180

            # Add bridged adapter; this will be used for all communication after the initial conifguration.
            node.vm.network "public_network", bridge: bridge_iface, auto_config: false, adapter: 2

            node.vm.provider "virtualbox" do |vb|
                vb.name = name
                vb.memory = details['memory'] || 1024
                vb.cpus = details['cpus'] || 1
                #vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
                vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
                vb.customize ["modifyvm", :id, "--macaddress2", "auto"]
                vb.customize ["modifyvm", :id, "--audio", "none"]                # No audio
                vb.customize ["modifyvm", :id, "--usb", "off"]                   # No USB controller
                vb.customize ["modifyvm", :id, "--usbehci", "off"]               # No EHCI USB
                vb.customize ["modifyvm", :id, "--usbxhci", "off"]               # No xHCI USB
                vb.customize ["modifyvm", :id, "--clipboard", "disabled"]        # No shared clipboard
                vb.customize ["modifyvm", :id, "--draganddrop", "disabled"]      # No drag-and-drop
                vb.customize ["modifyvm", :id, "--mouse", "none"]                # No mouse emulation
                vb.customize ["modifyvm", :id, "--keyboard", "ps2"]              # Use basic keyboard
                vb.customize ["modifyvm", :id, "--accelerate3d", "off"]          # No 3D acceleration
                vb.customize ["modifyvm", :id, "--vram", "16"]                   # Minimal video RAM
                vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]    # Disable serial port
            end
        end
    end
end

