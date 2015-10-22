class StateChecker
  def check!
    check_secret_token
    check_session_secret_key
  end

private

  def secret_token_path
    File.expand_path("~/.danbooru/secret_token")
  end

  def check_secret_token
    unless File.exists?(secret_token_path)
      raise "You must create a file in #{secret_token_path} containing a secret key. It should be a string of at least 32 random characters."
    end

    if File.stat(secret_token_path).world_readable? || File.stat(secret_token_path).world_writable?
      raise "#{secret_token_path} must not be world readable or writable" + "\n" + File.stat(secret_token_path).inspect
    end
  end

  def session_secret_key_path
    File.expand_path("~/.danbooru/session_secret_key")
  end

  def check_session_secret_key
    unless File.exists?(session_secret_key_path)
      raise "You must create a file in #{session_secret_key_path} containing a secret key. It should be a string of at least 32 random characters."
    end

    if File.stat(session_secret_key_path).world_readable? || File.stat(session_secret_key_path).world_writable?
      raise "#{session_secret_key_path} must not be world readable or writable"
    end
  end
end
