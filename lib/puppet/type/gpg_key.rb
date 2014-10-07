Puppet::Type.newtype(:gpg_key) do

  desc <<-EOT
    Manages GPG keys.
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path) do
    desc 'The file Puppet will ensure is imported.'
    
    isnamevar
    
    validate do |value|
      if File.expand_path(value) != value
        fail Puppet::Error, "File paths must be fully qualified, not '#{value}'"
      end
    end
  end

  newparam(:homedir) do
    desc 'Homedir option passed to gpg used to lookup .gnupg file path'
    defaultto '/root'
  end

  newparam(:private, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc 'Whether the gpg key is a private key or not'
    defaultto false
  end

  # Autorequire the file resource if it's being managed
  autorequire(:file) do
    self[:path]
  end
end
