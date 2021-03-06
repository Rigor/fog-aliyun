# frozen_string_literal: true

module Fog
  module Storage
    class Aliyun
      class Real
        def get_container(container, options = {})
          options = options.reject { |_key, value| value.nil? }

          bucket = options[:bucket]
          bucket ||= @aliyun_oss_bucket

          marker = options[:marker]
          maxKeys = options[:maxKeys]
          delimiter = '/'

          path = ''

          prefix = if container == '' || container == '.' || container.nil?
                     nil
                   else
                     container + '/'
                   end

          if prefix
            path += '?prefix=' + prefix
            path += '&marker=' + marker if marker
            path += '&max-keys=' + maxKeys if maxKeys
            path += '&delimiter=' + delimiter if delimiter
          elsif marker
            path += '?marker=' + marker
            path += '&max-keys=' + maxKeys if maxKeys
            path += '&delimiter=' + delimiter if delimiter
          elsif maxKeys
            path += '?max-keys=' + maxKeys
            path += '&delimiter=' + delimiter if delimiter
          elsif delimiter
            path += '?delimiter=' + delimiter
          end

          location = get_bucket_location(bucket)
          resource = bucket + '/'
          ret = request(
            expects: [200, 203, 400],
            method: 'GET',
            path: path,
            resource: resource,
            bucket: bucket
          )
          xml = ret.data[:body]
          XmlSimple.xml_in(xml)['CommonPrefixes']
        end
      end
    end
  end
end
