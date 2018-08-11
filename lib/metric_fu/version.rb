module MetricFu
  class Version
    MAJOR = "4"
    MINOR = "13"
    PATCH = "1"
    PRE   = ""
  end
  VERSION = [Version::MAJOR, Version::MINOR, Version::PATCH].join(".")
end
