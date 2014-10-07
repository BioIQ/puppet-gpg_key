Puppet::Type.type(:gpg_key).provide(:gpg) do

  @docs = "GPG Key type provider"
  if Facter.fact('operatingsystem').value =~ /Fedora/
    commands :gpg => "gpg2"
  else
    commands :gpg => "gpg" 
  end

  defaultfor :osfamily => :redhat
  confine :osfamily => :redhat

  def exists?
    if @resource[:private]
      gpg(["--homedir #{@resource[:homedir]}", "--list-secret-keys", "| grep #{@resource[:name]}"]) != ""
    else
      gpg(["--homedir #{@resource[:homedir]}", "--list-keys", "| grep #{@resource[:name]}"]) != ""
    end
  end

  def create
    if @resource[:private]
      gpg(["--homedir #{@resource[:homedir]}", "--allow-secret-key-import", "--import", @resource[:path]])
    else
      gpg(["--homedir #{@resource[:homedir]}", "--import", @resource[:path]])
    end
  end

  def destroy
    if @resource[:private]
      gpg(["--homedir #{@resource[:homedir]}", "--delete-secret-key", "'#{@resource[:name]}'"])
    else
      gpg(["--homedir #{@resource[:homedir]}", "--delete-key", "'#{@resource[:name]}'"])
    end
  end
end
