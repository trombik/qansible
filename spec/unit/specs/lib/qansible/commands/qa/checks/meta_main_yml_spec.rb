require "spec_helper"

module Qansible
  class Check
    describe MetaMainYaml do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When meta/main.yml is identical" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          MetaMainYaml.new
        end

        describe ".must_exist" do
          it "does not raise_error" do
            expect { instance.must_exist }.not_to raise_error
          end
        end

        describe ".must_be_yaml" do
          it "does not raise_error" do
            expect { instance.must_be_yaml }.not_to raise_error
          end

          it "returns Hash" do
            expect(instance.must_be_yaml.class).to eq(Hash)
          end
        end

        describe ".load_yaml" do
          it "does not raise_error" do
            expect { instance.load_yaml }.not_to raise_error
          end
        end

        describe ".must_have_galaxy_info" do
          it "does not raise error" do
            expect { instance.must_have_galaxy_info }.not_to raise_error
          end
        end

        describe ".must_not_have_old_format" do
          it "does not raise error" do
            expect { instance.must_not_have_old_format }.not_to raise_error
          end
        end

        describe ".must_have_mandatory_keys_in_galaxy_info" do
          it "does not raise error" do
            expect { instance.must_have_mandatory_keys_in_galaxy_info }.not_to raise_error
          end
        end

        describe ".should_not_have_default_description" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_not_have_default_description
          end
        end

        describe ".must_not_have_categories" do
          it "does not raise_error" do
            expect { instance.must_not_have_categories }.not_to raise_error
          end
        end

        describe ".must_not_have_min_ansible_version_less_than_2_0" do
          it "does not raise_error" do
            expect { instance.must_not_have_min_ansible_version_less_than_2_0 }.not_to raise_error
          end
        end

        describe ".must_have_at_least_one_platform_supported" do
          it "does not raise_error" do
            expect { instance.must_have_at_least_one_platform_supported }.not_to raise_error
          end
        end

        describe ".must_have_array_of_galaxy_tags" do
          it "does not raise_error" do
            expect { instance.must_have_array_of_galaxy_tags }.not_to raise_error
          end
        end

        describe ".should_have_at_least_one_tag" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_at_least_one_tag
          end
        end

        describe ".check" do
          it "does not warn more than once" do
            # by design, should_not_have_default_description cannot be
            # surpressed
            expect(instance).to receive(:warn).with(/description should describe the role, rather than the default. Add description in/).once
            instance.check
          end
        end
        describe ".check" do
          it "exits without error" do
            expect { instance.check }.not_to raise_error
          end
        end
      end
    end
  end
end
