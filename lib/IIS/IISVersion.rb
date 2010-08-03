include System::Diagnostics

class IISVersion
  def self.current_version()
    FileVersionInfo.GetVersionInfo(System::Environment.SystemDirectory + "\\inetsrv\\inetinfo.exe").product_version
  end
end