module ScrumAlliance
  module ActsAsHistoricallySluggable
    module ControllerExtensions
      def find_object_by_slug(object_name, opts={})
        class_inheritable_accessor :sluggable_object_name, :sluggable_redirect_to
        self.sluggable_object_name = object_name.to_s
        self.sluggable_redirect_to = opts[:redirect] || "#{sluggable_object_name}_path"
        
        include InstanceMethods
        before_filter :find_sluggable_and_redirect_on_outdated, opts
      end
      
      module InstanceMethods
      private
        def find_sluggable_and_redirect_on_outdated
          slug = Slug.find_by_identifier(params[:id]) || raise(ActiveRecord::RecordNotFound)
            
          object = slug.sluggable
          redirect_to(send(sluggable_redirect_to, :id => object.slug), :status => :moved_permanently) and return if object.current_slug != slug
          
          instance_variable_set("@#{sluggable_object_name}", object)
        end
      end
    end # ControllerExtensions
  end # ActsAsHistoricallySluggable
end # ScrumAlliance

ActionController::Base.extend ScrumAlliance::ActsAsHistoricallySluggable::ControllerExtensions