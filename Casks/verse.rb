cask "verse" do
  version "0.3.3"
  sha256 "a4dd36940f284ebb65cef02fa54282adec713fe6d892ade55b23b827a52aeaba"

  url "https://github.com/navneetbind/verse/releases/download/v#{version}/Verse-#{version}.dmg"
  name "Verse"
  desc "Synced YouTube Music lyrics in the menu bar"
  homepage "https://github.com/navneetbind/verse"

  depends_on macos: ">= :ventura"

  app "Verse.app"

  # Same as opening Verse once by hand: tell each installed browser where the
  # app lives (native-messaging host file) and put the extension somewhere
  # stable. Done here in Ruby because macOS would stop an unverified app that
  # a script launches. Browser list mirrors Setup.swift.
  postflight do
    support = File.expand_path("~/Library/Application Support")
    exe = "#{appdir}/Verse.app/Contents/MacOS/verse"
    browsers = {
      "Mozilla"                     => :gecko,
      "Google/Chrome"               => :chromium,
      "Google/Chrome Beta"          => :chromium,
      "Google/Chrome Canary"        => :chromium,
      "Chromium"                    => :chromium,
      "BraveSoftware/Brave-Browser" => :chromium,
      "Microsoft Edge"              => :chromium,
      "Vivaldi"                     => :chromium,
      "Arc/User Data"               => :chromium,
    }
    browsers.each do |dir, kind|
      base = File.join(support, dir)
      next unless File.directory?(base)

      host = { name: "verse", description: "Verse menu-bar lyrics host", path: exe, type: "stdio" }
      if kind == :gecko
        host[:allowed_extensions] = ["verse@local"]
      else
        host[:allowed_origins] = ["chrome-extension://gagjjbmjcifaamdoomimianilfhkiafc/"]
      end
      FileUtils.mkdir_p(File.join(base, "NativeMessagingHosts"))
      File.write(File.join(base, "NativeMessagingHosts", "verse.json"), JSON.pretty_generate(host))
    end

    ext = File.join(support, "Verse", "extension")
    FileUtils.rm_rf(ext)
    FileUtils.mkdir_p(File.dirname(ext))
    FileUtils.cp_r("#{appdir}/Verse.app/Contents/Resources/extension", ext)
  end

  # Remove only host files that point at this app, so a dev build stays registered.
  uninstall_postflight do
    exe = "#{appdir}/Verse.app/Contents/MacOS/verse"
    Dir.glob(File.expand_path("~/Library/Application Support/**/NativeMessagingHosts/verse.json")).each do |f|
      File.delete(f) if (JSON.parse(File.read(f))["path"] rescue nil) == exe
    end
  end

  zap trash: [
    "~/Library/Application Support/Verse",
    "~/Library/Preferences/com.navneetbind.verse.plist",
  ]

  caveats <<~EOS
    Verse is not notarized. Before first use, open it once from Applications
    (or allow it under System Settings > Privacy & Security > Open Anyway).

    Then add the browser extension from:
      ~/Library/Application Support/Verse/extension

      Chrome, Brave, Edge, Vivaldi, Arc: extensions page > Developer mode >
        Load unpacked > choose that folder.
      Firefox: about:debugging > This Firefox > Load Temporary Add-on >
        choose manifest.json in that folder (Firefox drops it on restart).

    Then play a song on music.youtube.com.
  EOS
end
