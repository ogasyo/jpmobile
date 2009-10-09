#DoCoMoの時uid=NULLGWDOCOMOの付与
class ActionController::Base #:nodoc:
  class_inheritable_accessor :docomo_uid_mode

  class << self
    def docomo_uid(mode=:docomo)
      include Jpmobile::DocomoUid
      self.docomo_uid_mode = mode
    end
  end
end


module Jpmobile::DocomoUid #:nodoc:
  protected
  def default_url_options(options=nil)
    result = super || {}
    return result unless request # for test process
    return result unless apply_add_uid?
    return result.merge({:uid => "NULLGWDOCOMO"})
  end

  #uid=NULLGWDOCOMOを付与すべきか否かを返す
  def apply_add_uid?
    return true if docomo_uid_mode == :always
    return false if docomo_uid_mode == :none

    return false unless request.mobile?
    return false unless request.mobile.is_a?(Jpmobile::Mobile::Docomo)
    return false if not_apply_uid_user_agent?

    if docomo_uid_mode == :valid_ip
      return false unless request.mobile.valid_ip?
    end

    return true
  end

  def not_apply_uid_user_agent?
    request.user_agent.match(/(?:Googlebot|Y!J-SRD\/1\.0|Y!J-MBS\/1\.0)/)
  end
end
