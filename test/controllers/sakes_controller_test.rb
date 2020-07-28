require "test_helper"

class SakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sake = sakes(:one)
  end

  test "should get index" do
    get sakes_url
    assert_response :success
  end

  test "should get new" do
    get new_sake_url
    assert_response :success
  end

  test "should create sake" do
    assert_difference("Sake.count") do
      post sakes_url,
           params: {
             sake: {
               name: @sake.name,
               kura: @sake.kura,
               photo: @sake.photo,
               bindume_date: @sake.bindume_date,
               brew_year: @sake.brew_year,
               todofuken: @sake.todofuken,
               taste_value: @sake.taste_value,
               aroma_value: @sake.aroma_value,
               nihonshudo: @sake.nihonshudo,
               sando: @sake.sando,
               aroma_impression: @sake.aroma_impression,
               color: @sake.color,
               taste_impression: @sake.taste_impression,
               nigori: @sake.nigori,
               awa: @sake.awa,
               tokutei_meisho: @sake.tokutei_meisho,
               genryoumai: @sake.genryoumai,
               kakemai: @sake.kakemai,
               kobo: @sake.kobo,
               alcohol: @sake.alcohol,
               aminosando: @sake.aminosando,
               season: @sake.season,
               warimizu: @sake.warimizu,
               moto: @sake.moto,
               seimai_buai: @sake.seimai_buai,
               roka: @sake.roka,
               shibori: @sake.shibori,
               note: @sake.note,
               bottle_level: @sake.bottle_level,
               hiire: @sake.hiire,
               price: @sake.price,
               size: @sake.size,
             },
           }
    end

    assert_redirected_to sake_url(Sake.last)
  end

  test "should show sake" do
    get sake_url(@sake)
    assert_response :success
  end

  test "should get edit" do
    get edit_sake_url(@sake)
    assert_response :success
  end

  test "should update sake" do
    patch sake_url(@sake),
          params: {
            sake: {
              name: @sake.name,
              kura: @sake.kura,
              photo: @sake.photo,
              bindume_date: @sake.bindume_date,
              brew_year: @sake.brew_year,
              todofuken: @sake.todofuken,
              taste_value: @sake.taste_value,
              aroma_value: @sake.aroma_value,
              nihonshudo: @sake.nihonshudo,
              sando: @sake.sando,
              aroma_impression: @sake.aroma_impression,
              color: @sake.color,
              taste_impression: @sake.taste_impression,
              nigori: @sake.nigori,
              awa: @sake.awa,
              tokutei_meisho: @sake.tokutei_meisho,
              genryoumai: @sake.genryoumai,
              kakemai: @sake.kakemai,
              kobo: @sake.kobo,
              alcohol: @sake.alcohol,
              aminosando: @sake.aminosando,
              season: @sake.season,
              warimizu: @sake.warimizu,
              moto: @sake.moto,
              seimai_buai: @sake.seimai_buai,
              roka: @sake.roka,
              shibori: @sake.shibori,
              note: @sake.note,
              bottle_level: @sake.bottle_level,
              hiire: @sake.hiire,
              price: @sake.price,
              size: @sake.size,
            },
          }
    assert_redirected_to sake_url(@sake)
  end

  test "should destroy sake" do
    assert_difference("Sake.count", -1) do
      delete sake_url(@sake)
    end

    assert_redirected_to sakes_url
  end
end
