require 'yaml'

config_data = YAML.load_file('vagrant/vagrant_config.yaml')

Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/jammy64"

    # Run checks to ensure the required environment variables are set.
    # Network Adapter
    bridge_iface = ENV["BRIDGE_IFACE"]
    raise "❌ BRIDGE_IFACE is not set. Use: BRIDGE_IFACE=enp1s0f0 make up" unless bridge_iface && !bridge_iface.empty?

    # Key Vault
    azure_vault_name = ENV["AZURE_VAULT_NAME"]
    raise "❌ AZURE_VAULT_NAME is not set. Use: ensure web/.env has been populated!" unless azure_vault_name && !azure_vault_name.empty?

    # Certificate Names
    azure_vault_cert_1 = ENV["AZURE_CERT_NAME_1"]
    raise "❌ AZURE_CERT_NAME_1 is not set. Use: ensure web/.env has been populated!" unless azure_vault_cert_1 && !azure_vault_cert_1.empty?

    # Certificate Names
    azure_vault_cert_2 = ENV["AZURE_CERT_NAME_2"]
    raise "❌ AZURE_CERT_NAME_2 is not set. Use: ensure web/.env has been populated!" unless azure_vault_cert_2 && !azure_vault_cert_2.empty?

    # Service Principal Id
    azure_sp_id = ENV["AZURE_SP_ID"]
    raise "❌ AZURE_SP_ID is not set. Use: ensure web/.env has been populated!" unless azure_sp_id && !azure_sp_id.empty?

    # Service Principal Secret
    azure_sp_secret = ENV["AZURE_SP_SECRET"]
    raise "❌ AZURE_SP_SECRET is not set. Use: ensure web/.env has been populated!" unless azure_sp_secret && !azure_sp_secret.empty?

    azure_tenant_id = ENV["TENANT_ID"]
    raise "❌ TENANT_ID is not set. Use: ensure web/.env has been populated!" unless azure_tenant_id && !azure_tenant_id.empty?

    config_data['nodes'].each do |name, details|
        ip = details['ip']
        raise "❌ IP address for #{name} is not set. Please check vagrant_config.yaml" unless ip && !ip.empty?
        role = details['role']
        raise "❌ Role for #{name} is not set. Please check vagrant_config.yaml" unless role && !role.empty?
        raise "❌ Role #{role} is not supported. Please check vagrant_config.yaml" unless ['web-server', 'data-server'].include?(role)

        config.vm.define name do |node|
            node.vm.hostname = name
            node.vm.boot_timeout = 180

            # Add bridged adapter; this will be used for all communication after the initial conifguration.
            node.vm.network "public_network", bridge: bridge_iface, auto_config: false, adapter: 2

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

            node.vm.provision "shell", path: "scripts/network.sh", env: { 
                "STATIC_IP"         => ip
            }

            node.vm.provision "shell", path: "scripts/software.sh"

            node.vm.provision "shell", path: "scripts/certificates.sh", env: {
                "AZURE_VAULT_NAME"  => azure_vault_name,
                "AZURE_CERT_NAME_1" => azure_vault_cert_1,
                "AZURE_CERT_NAME_2" => azure_vault_cert_2,
                "CLIENT_ID"         => azure_sp_id,
                "CLIENT_SECRET"     => azure_sp_secret,
                "TENANT_ID"         => azure_tenant_id
            }

            if role == "web-server"
                node.vm.synced_folder "web", "/vagrant/web", type: "virtualbox"
                node.vm.provision "shell", path: "web/config.sh"
            end
        end
    end
end

