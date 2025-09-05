AVAILABLE_COUNTRY = {
    "brunei":       "bn",
    "cambodia":     "kh",
    "east_timor":   "tl",
    "indonesia":    "id",
    "laos":         "la",
    "malaysia":     "my",
    "myanmar":      "mm",
    "philipines":   "ph",
    "singapore":    "sg",
    "thailand":     "th",
    "vietnam":      "vn"
}

def get_available_country(current_user):
    return {
        "data": AVAILABLE_COUNTRY
    }