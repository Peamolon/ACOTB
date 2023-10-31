FactoryBot.define do
  factory :bloom_taxonomy_level do
    comment { Faker::Lorem.sentence }
    level { BloomTaxonomyLevel::BLOOM_LEVELS.keys.sample }
    percentage { rand(0..100) }
  end
end
