# frozen_string_literal: true

module ActiveStorage::SetBlob #:nodoc:
  extend ActiveSupport::Concern

  included do
    before_action :set_blob
  end

  private
    def set_blob
      @blob = ActiveStorage::Blob.find_signed!(params[:signed_blob_id] || params[:signed_id])
      # CONTRIBUTE Check ActiveStorage::VariantRecord existence:
      @blob.representation(params[:variation_key]).present? if params[:variation_key].present?
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      head :not_found
    end
end
