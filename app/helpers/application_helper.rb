module ApplicationHelper
  #REf: https://gist.github.com/mynameispj/5692162
  def active_page?(current_page)
    return unless request.path.include?(current_page.to_s)
    'is-active'
  end

  #Take your pick: these two do the same thing!
  def is_active?(current_page)
    return "is-active" if params[:controller] == current_page.to_s
  end
end
