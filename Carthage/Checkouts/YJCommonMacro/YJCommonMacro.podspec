version = "0.0.5";

Pod::Spec.new do |s|

    s.name         = "YJCommonMacro"
    s.version      = version
    s.summary      = "YJCommonMacro 包含 iOS 开发中常用的宏, Author's email:houmanager@Hotmail.com 工作地点:BeiJing 欢迎骚扰。"
    s.description      = <<-DESC
    YJCommonMacro 包含 iOS 开发中常用的宏, Author's email:houmanager@Hotmail.com 工作地点:BeiJing 欢迎骚扰。欢迎大家提供更好的常用宏。
    DESC
    s.homepage     = "https://github.com/YJManager/YJCommonMacro"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "houmanager" => "houmanager@Hotmail.com" }
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/YJManager/YJCommonMacro.git", :tag => "#{version}"}
    s.source_files  = "YJCommonMacro/*.{h,m}"
    s.requires_arc = true

end
