class IISVersion
  def self.current_version()
    FileVersionInfo.GetVersionInfo(Environment.SystemDirectory + "\\inetsrv\\inetinfo.exe").product_version
  end
end