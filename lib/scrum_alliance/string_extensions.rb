module ScrumAlliance
  module ActsAsHistoricallySluggable
    module StringExtensions
      def slugify
        downcase.gsub(/[^a-z0-9_ ]/, '').squeeze(' ').strip.gsub(' ', '_')
      end
    end # StringExtensions
  end # ActsAsHistoricallySluggable
end # ScrumAlliance

String.class_eval { include ScrumAlliance::ActsAsHistoricallySluggable::StringExtensions }