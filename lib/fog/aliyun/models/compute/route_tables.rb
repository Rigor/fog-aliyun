# frozen_string_literal: true

require 'fog/core/collection'
require 'fog/aliyun/models/compute/route_table'

module Fog
  module Compute
    class Aliyun
      class RouteTables < Fog::Collection
        attribute :v_router

        model Fog::Compute::Aliyun::RouteTable

        def all(options = {})
          requires :v_router
          data = service.list_route_tables(v_router.id, options).body['RouteTables']['RouteTable']
          load(data)
        end

        def get(routeTableId)
          requires :v_router
          self.class.new(service: service, v_router: v_router).all(routeTableId: routeTableId)[0] if routeTableId
        end
      end
    end
  end
end
