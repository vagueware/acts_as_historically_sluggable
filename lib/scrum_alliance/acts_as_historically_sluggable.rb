module ScrumAlliance
  module ActsAsHistoricallySluggable
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    module ClassMethods
      def acts_as_historically_sluggable(method, opts={})
        class_inheritable_accessor :slug_method
        self.slug_method = method
        
        has_many :slugs, :as => :sluggable, :dependent => :destroy, :validate => false
        
        include InstanceMethods
        
        before_validation :build_slug
        validates_associated :current_slug, :message => "generated from #{slug_method} is not unique; try changing the #{slug_method}"
        after_save :create_slug
        
        extend SingletonMethods
      end
    end # ClassMethods
    
    module SingletonMethods
      def find_by_slug(value)
        first(:conditions => ["slugs.identifier = ?", value], :include => :slugs)
      end
    end # SingletonMethods
    
    module InstanceMethods
      def slug
        current_slug ? current_slug.identifier : ''
      end
      alias_method :to_param, :slug
      
      def slug_changed?
        changed.include?(slug_method.to_s)
      end
      
      def current_slug
        slugs.last
      end
      
    private
      def build_slug
        return unless slug_changed?
        
        existing_slug = Slug.find_by_identifier_and_sluggable_type(slug_identifier, self.class.to_s)
        existing_slug.destroy if existing_slug.try(:historical?) # it's kosher to re-use slugs that aren't in use
        
        slugs.build(:identifier => slug_identifier)
      end
      
      def create_slug
        return unless slug_changed?
        current_slug.save
      end
      
      def slug_identifier
        send(slug_method).to_s.slugify
      end
    end # InstanceMethods
  end # ActsAsHistoricallySluggable
end # ScrumAlliance

ActiveRecord::Base.class_eval { include ScrumAlliance::ActsAsHistoricallySluggable }