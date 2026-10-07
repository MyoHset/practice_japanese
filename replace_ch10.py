import json

file_path = '/home/myohset/projects/practice_janpanese/assets/data/kanji_speed_master_n3.json'

with open(file_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

new_chapter = {
    "chapter": 10,
    "title": "Ch.10: 学校 (ကျောင်း / ကလေးနှင့် စာသင်ခန်း)",
    "kanjis": [
        {
            "character": "幼",
            "onyomi": "ヨウ",
            "kunyomi": "おさな・い",
            "meaning": "ငယ်ရွယ်သော",
            "vocab": [
                {"word": "幼い", "reading": "おさない", "meaning": "ငယ်ရွယ်သော"},
                {"word": "幼稚園", "reading": "ようちえん", "meaning": "မူကြိုကျောင်း"},
                {"word": "幼友達", "reading": "おさなともだち", "meaning": "ငယ်သူငယ်ချင်း"},
                {"word": "幼少期", "reading": "ようしょうき", "meaning": "ကလေးဘဝအချိန်များ"}
            ]
        },
        {
            "character": "児",
            "onyomi": "ジ / ニ",
            "kunyomi": "",
            "meaning": "ကလေးငယ်",
            "vocab": [
                {"word": "児", "reading": "じ", "meaning": "ကလေးငယ်"},
                {"word": "小児科", "reading": "しょうにか", "meaning": "ကလေးအထူးကုဆေးပညာ"},
                {"word": "育児", "reading": "いくじ", "meaning": "ကလေးပြုစုပျိုးထောင်ခြင်း"},
                {"word": "幼児", "reading": "ようじ", "meaning": "ကလေးငယ် / Toddler"},
                {"word": "乳児", "reading": "にゅうじ", "meaning": "နှို့စို့ကလေး"}
            ]
        },
        {
            "character": "童",
            "onyomi": "ドウ",
            "kunyomi": "わらべ",
            "meaning": "ကလေး",
            "vocab": [
                {"word": "童", "reading": "わらべ", "meaning": "ကလေး"},
                {"word": "童歌", "reading": "わらべうた", "meaning": "ကလေးချော့သီချင်း"},
                {"word": "童話", "reading": "どうわ", "meaning": "ကလေးပုံပြင်"},
                {"word": "児童", "reading": "じどう", "meaning": "ကလေးများ"},
                {"word": "児童会長", "reading": "じどうかいちょう", "meaning": "ကလေးဥက္ကဋ္ဌ"},
                {"word": "童心", "reading": "どうしん", "meaning": "ကလေးစိတ်"}
            ]
        },
        {
            "character": "徒",
            "onyomi": "ト",
            "kunyomi": "",
            "meaning": "တပည့် / ဂျူနီယာ",
            "vocab": [
                {"word": "生徒", "reading": "せいと", "meaning": "တပည့် / ကျောင်းသား"},
                {"word": "教徒", "reading": "きょうと", "meaning": "ယုံကြည်ဆည်းကပ်သူများ"},
                {"word": "徒労", "reading": "とろう", "meaning": "အလဟဿ အားထုတ်မှု"},
                {"word": "徒歩で", "reading": "とほで", "meaning": "ခြေလျင်လမ်းလျှောက်၍"}
            ]
        },
        {
            "character": "担",
            "onyomi": "タン",
            "kunyomi": "かつ・ぐ、にな・う",
            "meaning": "ထမ်းဆောင် / တာဝန်ယူခြင်း",
            "vocab": [
                {"word": "担当", "reading": "たんとう", "meaning": "တာဝန်ယူခြင်း"},
                {"word": "担ぐ", "reading": "かつぐ", "meaning": "ထမ်းသည်"},
                {"word": "担う", "reading": "になう", "meaning": "ထမ်းဆောင်သည်"},
                {"word": "負担", "reading": "ふたん", "meaning": "ဝန်ထုပ်ဝန်ပိုး"}
            ]
        },
        {
            "character": "任",
            "onyomi": "ニン",
            "kunyomi": "まか・せる",
            "meaning": "တာဝန်လွှဲအပ်ခြင်း",
            "vocab": [
                {"word": "任せる", "reading": "まかせる", "meaning": "တာဝန်လွှဲအပ်သည်"},
                {"word": "責任", "reading": "せきにん", "meaning": "တာဝန်ယူမှု"},
                {"word": "任命する", "reading": "にんめいする", "meaning": "ခန့်အပ်သည်"},
                {"word": "辞任する", "reading": "じにんする", "meaning": "နှုတ်ထွက်သည်"}
            ]
        },
        {
            "character": "師",
            "onyomi": "シ",
            "kunyomi": "",
            "meaning": "ဆရာ / အထူးကု",
            "vocab": [
                {"word": "教師", "reading": "きょうし", "meaning": "ကျောင်းဆရာ / နည်းပြ"},
                {"word": "医師", "reading": "いし", "meaning": "ဆရာဝန်"},
                {"word": "恩師", "reading": "おんし", "meaning": "ကျေးဇူးရှင်ဆရာ"},
                {"word": "調理師", "reading": "ちょうりし", "meaning": "လိုင်စင်ရစားဖိုမှူး"},
                {"word": "師走", "reading": "しわす", "meaning": "၁၂ လပိုင်း (ဒီဇင်ဘာလ)"}
            ]
        },
        {
            "character": "組",
            "onyomi": "ソ",
            "kunyomi": "くみ、く・む",
            "meaning": "အဖွဲ့ / စုစည်းခြင်း",
            "vocab": [
                {"word": "組", "reading": "くみ", "meaning": "အတန်း / အဖွဲ့"},
                {"word": "番組", "reading": "ばんぐみ", "meaning": "တီဗီအစီအစဉ်"},
                {"word": "組み合わせる", "reading": "くみあわせる", "meaning": "ပေါင်းစပ်သည်"},
                {"word": "組織", "reading": "そしき", "meaning": "အဖွဲ့အစည်း"}
            ]
        },
        {
            "character": "机",
            "onyomi": "キ",
            "kunyomi": "つくえ",
            "meaning": "စာရေးစားပွဲ",
            "vocab": [
                {"word": "机", "reading": "つくえ", "meaning": "စားပွဲခုံ"},
                {"word": "学習机", "reading": "がくしゅうづくえ", "meaning": "စာရေးစားပွဲ"},
                {"word": "机上", "reading": "きじょう", "meaning": "စားပွဲပေါ်တွင် / လက်တွေ့မပါသေးသော"}
            ]
        },
        {
            "character": "座",
            "onyomi": "ザ",
            "kunyomi": "すわ・る",
            "meaning": "ထိုင်ခြင်း / ထိုင်ခုံ",
            "vocab": [
                {"word": "座る", "reading": "すわる", "meaning": "ထိုင်သည်"},
                {"word": "正座", "reading": "せいざ", "meaning": "ဒူးတုပ်ထိုင်ခြင်း"},
                {"word": "星座", "reading": "せいざ", "meaning": "ရာသီခွင်"},
                {"word": "座席", "reading": "ざせき", "meaning": "ထိုင်ခုံ"}
            ]
        },
        {
            "character": "板",
            "onyomi": "ハン / バン",
            "kunyomi": "いた",
            "meaning": "ပျဉ်ပြား / သင်ပုန်း",
            "vocab": [
                {"word": "板", "reading": "いた", "meaning": "ပျဉ်ပြား"},
                {"word": "黒板", "reading": "こくばん", "meaning": "ကျောက်သင်ပုန်း"},
                {"word": "まな板", "reading": "まないた", "meaning": "စဉ်းတီတုံး"},
                {"word": "板前", "reading": "いたまえ", "meaning": "ဂျပန်စားဖိုမှူး"},
                {"word": "板書", "reading": "ばんしょ", "meaning": "သင်ပုန်းပေါ်ရေးသားချက်"}
            ]
        },
        {
            "character": "筆",
            "onyomi": "ヒツ",
            "kunyomi": "ふで",
            "meaning": "ရေးသားခြင်း / စုတ်တံ",
            "vocab": [
                {"word": "筆", "reading": "ふで", "meaning": "စုတ်တံ"},
                {"word": "鉛筆", "reading": "えんぴつ", "meaning": "ခဲတံ"},
                {"word": "万年筆", "reading": "まんねんひつ", "meaning": "ဖောင်တိန်"},
                {"word": "筆者", "reading": "ひっしゃ", "meaning": "စာရေးသူ"},
                {"word": "筆記試験", "reading": "ひっきしけん", "meaning": "ရေးဖြေစာမေးပွဲ"}
            ]
        },
        {
            "character": "貸",
            "onyomi": "タイ",
            "kunyomi": "か・す",
            "meaning": "ငှားပေးခြင်း",
            "vocab": [
                {"word": "貸す", "reading": "かす", "meaning": "ငှားပေးသည်"},
                {"word": "貸会議室", "reading": "しかいぎしつ", "meaning": "အငှားအစည်းအဝေးခန်း"},
                {"word": "貸借", "reading": "たいしゃく", "meaning": "ချေးငှားခြင်း"},
                {"word": "貸切る", "reading": "かしきる", "meaning": "အပြတ်ငှားသည်"}
            ]
        },
        {
            "character": "借",
            "onyomi": "シャク",
            "kunyomi": "か・りる",
            "meaning": "ငှားယူခြင်း",
            "vocab": [
                {"word": "借りる", "reading": "かりる", "meaning": "ငှားယူသည်"},
                {"word": "借金", "reading": "しゃっきん", "meaning": "ချေးငွေ / ကြွေးမြီ"},
                {"word": "借地", "reading": "しゃくち", "meaning": "မြေငှား"}
            ]
        },
        {
            "character": "返",
            "onyomi": "ハン",
            "kunyomi": "かえ・る、かえ・す",
            "meaning": "ပြန်ပေး / အကြောင်းပြန်ခြင်း",
            "vocab": [
                {"word": "返す", "reading": "かえす", "meaning": "ပြန်ပေးသည်"},
                {"word": "返信", "reading": "へんしん", "meaning": "အကြောင်းပြန်စာ"},
                {"word": "振り返る", "reading": "ふりかえる", "meaning": "နောက်ပြန်လှည့်ကြည့်သည်"},
                {"word": "繰り返す", "reading": "くりかえす", "meaning": "ထပ်မံလုပ်ဆောင်သည်"},
                {"word": "返事", "reading": "へんじ", "meaning": "အကြောင်းပြန်ခြင်း"}
            ]
        },
        {
            "character": "冊",
            "onyomi": "サツ / サク",
            "kunyomi": "",
            "meaning": "စာအုပ်ရေတွက်ခြင်း",
            "vocab": [
                {"word": "冊", "reading": "さつ", "meaning": "အုပ် (စာအုပ်ရေတွက်ရန်)"},
                {"word": "三冊", "reading": "さんさつ", "meaning": "သုံးအုပ်"},
                {"word": "別冊", "reading": "べっさつ", "meaning": "သီးခြားဖြည့်စွက်ချက်"},
                {"word": "小冊子", "reading": "しょうさっし", "meaning": "ကြော်ငြာစာရွက် / Pamphlet"}
            ]
        },
        {
            "character": "具",
            "onyomi": "グ",
            "kunyomi": "",
            "meaning": "ပစ္စည်းကိရိယာ",
            "vocab": [
                {"word": "道具", "reading": "どうぐ", "meaning": "ပစ္စည်းကိရိယာများ"},
                {"word": "文具店", "reading": "ぶんぐてん", "meaning": "စာရေးကိရိယာဆိုင်"},
                {"word": "具体例", "reading": "ぐたいれい", "meaning": "ခိုင်မာသောဥပမာ"},
                {"word": "家具", "reading": "かぐ", "meaning": "ပရိဘောဂ"},
                {"word": "遊具", "reading": "ゆうぐ", "meaning": "ကစားကွင်းပစ္စည်းများ"}
            ]
        },
        {
            "character": "箱",
            "onyomi": "ソウ",
            "kunyomi": "はこ",
            "meaning": "သေတ္တာ / ဗူး",
            "vocab": [
                {"word": "箱", "reading": "はこ", "meaning": "ဗူး / သေတ္တာ"},
                {"word": "ゴミ箱", "reading": "ごみばこ", "meaning": "အမှိုက်ပုံး"},
                {"word": "本箱", "reading": "ほんばこ", "meaning": "စာအုပ်စင်"}
            ]
        },
        {
            "character": "棒",
            "onyomi": "ボウ",
            "kunyomi": "",
            "meaning": "တုတ်တိုင်",
            "vocab": [
                {"word": "棒", "reading": "ぼう", "meaning": "တုတ်တိုင်"},
                {"word": "鉄棒", "reading": "てつぼう", "meaning": "သံတိုင်"},
                {"word": "泥棒", "reading": "どろぼう", "meaning": "သူခိုး"}
            ]
        },
        {
            "character": "伸",
            "onyomi": "シン",
            "kunyomi": "の・びる、の・ばす",
            "meaning": "ဆန့်ထုတ် / ရှည်ထွက်ခြင်း",
            "vocab": [
                {"word": "伸びる", "reading": "のびる", "meaning": "ရှည်ထွက်သည်"},
                {"word": "伸ばす", "reading": "のばす", "meaning": "ဆွဲဆန့်သည်"},
                {"word": "屈伸", "reading": "くっしん", "meaning": "အကြောဆန့်ခြင်း"},
                {"word": "伸びをする", "reading": "のびをする", "meaning": "အကြောဆန့်သည်"}
            ]
        }
    ]
}

for i, chapter in enumerate(data['chapters']):
    if chapter['chapter'] == 10:
        data['chapters'][i] = new_chapter
        break

with open(file_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Done replacing chapter 10.")
