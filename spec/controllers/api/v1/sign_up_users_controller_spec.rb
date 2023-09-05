# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::SignUpUsersController do
  describe "POST #create" do
    let(:params) do
      {
        user: {
          name:,
          email:,
          password:
        }
      }
    end

    context "when create user successfully" do
      let(:name) { "test" }
      let(:email) { "test@gmail.com" }
      let(:password) { "Aa@123456" }

      before { post :create, params: }

      it { expect(response_data[:success]).to eq true }
    end

    context "when email invalid" do
      let(:name) { "test" }
      let(:email) { "test2@@gmail.com" }
      let(:password) { "Aa@123456" }

      before { post :create, params: }

      it do
        expect(response_data[:success]).to eq false
        expect(response_data[:errors][0][:resource]).to eq "user"
        expect(response_data[:errors][0][:field]).to eq "email"
        expect(response_data[:errors][0][:code]).to eq 1009
      end
    end

    context "when email was taken" do
      let!(:user) { create :user, email: "test2@gmail.com" }

      let(:name) { "test" }
      let(:email) { "test2@gmail.com" }
      let(:password) { "Aa@123456" }

      before { post :create, params: }

      it do
        expect(response_data[:success]).to eq false
        expect(response_data[:errors][0][:resource]).to eq "user"
        expect(response_data[:errors][0][:field]).to eq "email"
        expect(response_data[:errors][0][:code]).to eq 1008
      end
    end

    context "when email was nil" do
      let(:name) { "test" }
      let(:email) { "" }
      let(:password) { "Aa@123456" }

      before { post :create, params: }

      it do
        expect(response_data[:success]).to eq false
        expect(response_data[:errors][0][:resource]).to eq "user"
        expect(response_data[:errors][0][:field]).to eq "email"
        expect(response_data[:errors][0][:code]).to eq 1009
      end
    end

    context "when password was wrong format" do
      let(:params) do
        {
          user: {
            name: "test",
            email: "email@gmail.com"
          }
        }
      end

      before { post :create, params: }

      it do
        expect(response_data[:success]).to eq false
        expect(response_data[:errors][0][:resource]).to eq "user"
        expect(response_data[:errors][0][:field]).to eq "password"
        expect(response_data[:errors][0][:code]).to eq 1800
      end
    end

    context "when missing user param" do
      let(:params) do
        {
          name: "name",
          email: "email@gmail.com",
          password: "Aa@123456"
        }
      end

      before { post :create, params: }

      it do
        expect(response_data[:success]).to eq false
        expect(response_data[:errors][0][:code]).to eq 1200
      end
    end
  end
end
