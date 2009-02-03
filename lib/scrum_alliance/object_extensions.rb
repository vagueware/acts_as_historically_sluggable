module ScrumAlliance
  module ActsAsHistoricallySluggable
    module ObjectExtensions
      def try(method, *args, &block)
        send(method, *args, &block) if respond_to?(method, true)
      end
    end # ScrumAlliance
  end # ActsAsHistoricallySluggable
end # ScrumAlliance

Object.class_eval { include ScrumAlliance::ActsAsHistoricallySluggable::ObjectExtensions } unless Object.instance_methods.include?('try')