class PixivWebAgent
  def self.phpsessid(agent)
    agent.cookies.select do |cookie| cookie.name == "PHPSESSID" end.first.try(:value)
  end

  def self.build
    mech = Mechanize.new
    phpsessid = Cache.get("pixiv-phpsessid")

    if phpsessid
      cookie = Mechanize::Cookie.new("PHPSESSID", phpsessid)
      cookie.domain = ".pixiv.net"
      cookie.path = "/"
      mech.cookie_jar.add(cookie)
    else
      mech.get("https://www.secure.pixiv.net") do |page|
        page.form_with(:action => "https://www.secure.pixiv.net/login.php") do |form|
          form['pixiv_id'] = Danbooru.config.pixiv_login
          form['pass'] = Danbooru.config.pixiv_password
        end.click_button
      end
      phpsessid = mech.cookie_jar.cookies.select{|c| c.name == "PHPSESSID"}.first
      Cache.put("pixiv-phpsessid", phpsessid.value, 1.month) if phpsessid
    end

    mech
  end
end
