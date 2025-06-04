require 'yaml'

config_data = YAML.load_file('vagrant/vagrant_config.yaml')

Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/jammy64"

    # NCheck the network adapter variable is set....
    bridge_iface = ENV["BRIDGE_IFACE"]
    raise "❌ BRIDGE_IFACE is not set. Use: BRIDGE_IFACE=enp1s0f0 make up" unless bridge_iface && !bridge_iface.empty?

    # Loop through nodes - pulled from vagrant_config.yaml
    config_data['nodes'].each do |name, details|
        ip = details.fetch("ip")
        role = details.fetch("role")
        framework = details.fetch("framework")
        tls_enabled = details.fetch("tls", false)
        cert_names = details.fetch("certificates", []) || []
        web_sites = details.fetch("sites", []) || []

        config.vm.define name do |node|
            node.vm.hostname = name
            node.vm.boot_timeout = 180

            # Add bridged adapter; this will be used for all communication after the initial conifguration.
            node.vm.network "public_network", bridge: bridge_iface, auto_config: false, adapter: 2

            # Configure the virtual box...
            node.vm.provider "virtualbox" do |vb|
                vb.name = name
                vb.memory = details['memory'] || 1024
                vb.cpus = details['cpus'] || 1
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

            # Configure networking...
            node.vm.provision "shell", path: "scripts/network.sh", env: { 
                "STATIC_IP"         => ip
            }

            # Install software and other prerequisite tools
            if role == "web-server"
                node.vm.provision "shell", path: "scripts/web-software.sh"
            end

            if tls_enabled
                # Grab variables passed in from web/.env
                azure_vault_name = ENV["AZURE_VAULT_NAME"]
                azure_sp_id = ENV["AZURE_SP_ID"]
                azure_sp_secret = ENV["AZURE_SP_SECRET"]
                azure_tenant_id = ENV["TENANT_ID"]

                raise "❌ Missing required environment variables - please define in web/.env" unless azure_vault_name && azure_sp_id && azure_sp_secret && azure_tenant_id

                node.vm.provision "shell",
                    path: "scripts/certificates.sh",
                    args: cert_names, 
                    env: {
                        "AZURE_VAULT_NAME"  => azure_vault_name,
                        "CLIENT_ID"         => azure_sp_id,
                        "CLIENT_SECRET"     => azure_sp_secret,
                        "TENANT_ID"         => azure_tenant_id
                    }
            end

            # if role == "web-server"
            #     node.vm.synced_folder "web", "/vagrant/web", type: "virtualbox"
            #     node.vm.provision "shell",
            #     path: "scripts/web-server.sh",
            #     args: web_sites
            # end

            if role == "load-balancer"
                node.vm.synced_folder "load_balancer", "/vagrant/lb", type: "virtualbox"
                node.vm.provision "shell", path: "script/load-balancer.sh"
            end
        end
    end
end

