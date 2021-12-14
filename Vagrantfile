# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

HOSTNAME = "sym6dev"
DOMAIN = "virtual.ballardini.com.ar"
HOST_IP_ADDRESS="192.168.56.10"

$msg = <<MSG
------------------------------------------------------
Symfony6 local environment

* http://#{HOST_IP_ADDRESS}/phpmyadmin
* http://#{HOSTNAME}.#{DOMAIN}/phpmyadmin

* credenciales PHPMyAdmin: root / root123
(las mismas que para admin de MariaDB)

#{HOSTNAME} -> #{HOST_IP_ADDRESS}


------------------------------------------------------
MSG

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    # uso cachier con NFS solamente si el hostmanager gestiona los nombres en /etc/hosts del host
    if Vagrant.has_plugin?("vagrant-cachier")
      # Configure cached packages to be shared between instances of the same base box.
      # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
      config.cache.scope = :box

      config.cache.synced_folder_opts = {
        owner: "_apt"
      }

      # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
   end

  end

 config.vm.post_up_message = $msg

 config.vm.define HOSTNAME do |srv|

    srv.vm.box = "debian/bullseye64"

    srv.vm.network "private_network", ip: HOST_IP_ADDRESS
    srv.vm.box_check_update = false
    srv.ssh.forward_agent = true
    srv.ssh.forward_x11 = true
    srv.vm.hostname = HOSTNAME

    if Vagrant.has_plugin?("vagrant-hostmanager")
      srv.hostmanager.aliases = %W(#{HOSTNAME+"."+DOMAIN})
    end

    srv.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.cpus = 2
      vb.memory = "2048"

      # https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm mas parametros para personalizar en VB
    end
  end

    ##
    # Aprovisionamiento
    #
    config.vm.provision "fix-no-tty", type: "shell" do |s|  # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
        s.privileged = false
        s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end
    config.vm.provision "ssh_pub_key", type: :shell do |s|
      begin
          ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
          s.inline = <<-SHELL
            mkdir -p /root/.ssh/
            touch /root/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
          SHELL
      rescue
          puts "No hay claves publicas en el HOME de su pc"
          s.inline = "echo OK sin claves publicas"
      end
    end

    config.vm.provision "actualiza", type: "shell" do |s|
        s.privileged = false
        s.inline = <<-SHELL
          export DEBIAN_FRONTEND=noninteractive
          export APT_LISTCHANGES_FRONTEND=none
          export APT_OPTIONS=' -y --allow-downgrades --allow-remove-essential --allow-change-held-packages -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold '

          sudo -E apt-get --purge remove apt-listchanges -y > /dev/null 2>&1
          sudo -E apt-get update -y -qq > /dev/null 2>&1
          sudo dpkg-reconfigure --frontend=noninteractive libc6 > /dev/null 2>&1
          [ $( lsb_release -is ) != "Debian" ] && sudo -E apt-get install linux-image-generic ${APT_OPTIONS}
          sudo -E apt-get upgrade ${APT_OPTIONS} > /dev/null 2>&1
          sudo -E apt-get dist-upgrade ${APT_OPTIONS} > /dev/null 2>&1
          sudo -E apt-get autoremove -y > /dev/null 2>&1
          sudo -E apt-get autoclean -y > /dev/null 2>&1
          sudo -E apt-get clean > /dev/null 2>&1

        SHELL
    end

    config.vm.provision :reload

    config.vm.provision "ansible-provision", type: :ansible do |ansible|
      ansible.playbook = "provision/ansible/site.yml"
      ansible.verbose = "vv"
      ansible.become= false
    end

    config.vm.provision "corre_goss", type: :ansible do |ansible|
      ansible.playbook = "provision/ansible/goss-tests.yml"
      ansible.become= false
    end

end

