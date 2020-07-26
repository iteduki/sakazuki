class Sake < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  enum bottle_level: {
    sealed: 0,
    opened: 1,
    empty: 2,
  }
  enum hiire: {
    unknown: 0,
    namanama: 1,
    mae_hiire: 2,
    ato_hiire: 3,
    nido_hiire: 4,
  }, _prefix: true
  enum tokutei_meisho: {
    none: 0,
    honjozo: 1,
    ginjo: 2,
    daiginjo: 3,
    junmai: 4,
    junmai_ginjo: 5,
    junmai_daiginjo: 6,
    tokubetsu_honjozo: 7,
    tokubetsu_junmai: 8,
  }, _prefix: true
  enum moto: {
    unknown: 0,
    kimoto: 1,
    yamahai: 2,
    sokujo: 3,
  }, _prefix: true
  enum warimizu: {
    unknown: 0,
    kasui: 1,
    genshu: 2,
  }, _prefix: true

  validates :name, presence: true
  validates :kura, exclusion: { in: [nil] }
  # validates :photo
  # validates :bindume_date,
  # validates :brew_year,
  validates :todofuken, exclusion: { in: [nil] }
  validates :taste_value,
            numericality:
            {
              allow_nil: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 10,
            }
  validates :aroma_value,
            numericality:
            {
              allow_nil: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 10,
            }
  validates :nihonshudo, numericality: { allow_nil: true }
  validates :sando, numericality: { allow_nil: true }
  validates :aroma_impression, exclusion: { in: [nil] }
  validates :color, exclusion: { in: [nil] }
  validates :taste_impression, exclusion: { in: [nil] }
  validates :nigori, exclusion: { in: [nil] }
  validates :awa, exclusion: { in: [nil] }
  validates :tokutei_meisho, presence: true
  validates :genryoumai, exclusion: { in: [nil] }
  validates :kakemai, exclusion: { in: [nil] }
  validates :kobo, exclusion: { in: [nil] }
  validates :alcohol, presence: true
  validates :aminosando, numericality: { allow_nil: true }
  validates :season, exclusion: { in: [nil] }
  validates :warimizu, presence: true
  validates :moto, exclusion: { in: [nil] }
  validates :seimai_buai, numericality: { allow_nil: true }
  validates :roka, exclusion: { in: [nil] }
  validates :shibori, exclusion: { in: [nil] }
  validates :note, exclusion: { in: [nil] }
  validates :bottle_level, presence: true
  validates :hiire, presence: true
  validates :price, numericality: { allow_nil: true }
  validates :size, numericality: true
end
