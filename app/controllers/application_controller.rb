class ApplicationController < ActionController::Base

  def param_preps(param)
    param.downcase.split(',').map(&:strip).map { |val| "%#{val}%" }
  end

  helper_method :param_preps
end
