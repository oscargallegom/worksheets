class FarmSweeper < ActionController::Caching::Sweeper
  observe Farm
 
  def after_create(farm)
    expire_cache_for(farm)
  end
 
  def after_update(farm)
    expire_cache_for(farm)
  end
 
  def after_destroy(farm)
    expire_cache_for(farm)
  end
 
  private
  def expire_cache_for(farm)
    expire_page(:controller => 'farms', :action => 'index')
 
    expire_fragment('all_farms')
  end
end