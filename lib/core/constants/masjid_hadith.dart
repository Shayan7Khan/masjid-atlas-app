import 'dart:math';
import 'package:flutter_antonx_boilerplate/core/models/hadith_model.dart';

class MasjidHadiths {
  static final List<Hadith> _hadiths = [
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "Whoever goes to the masjid morning and evening, Allah prepares for him a place in Jannah.",
      reference: "Sahih Bukhari 662",
    ),
    Hadith(
      narrator: "Buraidah (رضي الله عنه)",
      text:
          "Give glad tidings to those who walk to the masjid in darkness of complete light on the Day of Resurrection.",
      reference: "Sunan Ibn Majah 781",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "The most beloved places to Allah are the mosques.",
      reference: "Sahih Muslim 671",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "A man's prayer in congregation is twenty-seven times superior to his prayer alone.",
      reference: "Sahih Bukhari 645",
    ),
    Hadith(
      narrator: "Uthman ibn Affan (رضي الله عنه)",
      text:
          "Whoever performs wudu perfectly and walks to the masjid, Allah forgives him for every step he takes.",
      reference: "Sahih Muslim 666",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "The angels pray for one of you as long as he remains seated in the place he prayed.",
      reference: "Sahih Bukhari 445",
    ),
    Hadith(
      narrator: "Abu Musa (رضي الله عنه)",
      text:
          "The one who gets the greatest reward for the prayer is the one who walks the farthest to the masjid.",
      reference: "Sahih Muslim 662",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "The Prophet said the masjid is the house of every righteous believer.",
      reference: "Musnad Ahmad 12329",
    ),
    Hadith(
      narrator: "Abdullah bin Umar (رضي الله عنه)",
      text:
          "Do not prevent the female servants of Allah from the masjids of Allah.",
      reference: "Sahih Muslim 442",
    ),
    Hadith(
      narrator: "Abu Qatadah (رضي الله عنه)",
      text: "When the iqamah is pronounced, do not stand until you see me.",
      reference: "Sahih Bukhari 637",
    ),
    Hadith(
      narrator: "Bilal (رضي الله عنه)",
      text:
          "The Prophet instructed: Let the one who calls the adhan be trustworthy and responsible.",
      reference: "Sunan Ibn Majah 714",
    ),
    Hadith(
      narrator: "Aisha (رضي الله عنها)",
      text: "The Prophet loved actions done consistently, even if small.",
      reference: "Sahih Bukhari 6464",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "Whoever purifies himself in his house then walks to a house of Allah to perform an obligatory prayer, each step removes a sin and raises a rank.",
      reference: "Sahih Muslim 666",
    ),
    Hadith(
      narrator: "Ibn Abbas (رضي الله عنه)",
      text:
          "Anyone who builds a masjid for Allah, Allah builds for him a house in Paradise.",
      reference: "Sahih Bukhari 450",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "The Prophet said: The martyrs are five… and one who dies on his way to the masjid also has great reward.",
      reference: "Sahih Bukhari 653",
    ),
    Hadith(
      narrator: "Abdullah ibn Salam (رضي الله عنه)",
      text:
          "Spread salam, feed people, pray at night, and you will enter Paradise with peace.",
      reference: "Sunan Ibn Majah 1334",
    ),
    Hadith(
      narrator: "Anas (رضي الله عنه)",
      text:
          "The Prophet would hasten to the masjid whenever the prayer time entered.",
      reference: "Sahih Muslim 601",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text:
          "If people knew the reward for praying Isha and Fajr in congregation, they would come even if they had to crawl.",
      reference: "Sahih Bukhari 615",
    ),
    Hadith(
      narrator: "Abu Umamah (رضي الله عنه)",
      text:
          "Whoever leaves for the masjid only for prayer, Allah prepares hospitality for him in Paradise.",
      reference: "Musnad Ahmad 22186",
    ),
    Hadith(
      narrator: "Ibn Umar (رضي الله عنه)",
      text:
          "The Prophet commanded us to build masjids in our neighborhoods and keep them clean.",
      reference: "Sunan Ibn Majah 750",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "The rows of prayer are part of the beauty of the Ummah.",
      reference: "Sahih Muslim 436",
    ),
    Hadith(
      narrator: "Anas (رضي الله عنه)",
      text:
          "Straighten your rows, for straightening rows is part of establishing prayer.",
      reference: "Sahih Bukhari 723",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "The imam is appointed to be followed.",
      reference: "Sahih Bukhari 722",
    ),
    Hadith(
      narrator: "Abu Mas’ud (رضي الله عنه)",
      text: "The one who leads should make the prayer light.",
      reference: "Sahih Bukhari 703",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "Do not rush to the masjid. Walk with tranquility.",
      reference: "Sahih Bukhari 908",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "When the iqamah is called, the gates of Heaven are opened.",
      reference: "Sahih Muslim 851",
    ),
    Hadith(
      narrator: "Anas (رضي الله عنه)",
      text:
          "The Prophet used to pray long when he was alone and short when leading.",
      reference: "Sahih Bukhari 703",
    ),
    Hadith(
      narrator: "Aisha (رضي الله عنها)",
      text: "The Prophet never left the two rak'ah before Fajr.",
      reference: "Sahih Bukhari 1169",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "Angels record everyone sitting in the masjid remembering Allah.",
      reference: "Sahih Muslim 2689",
    ),
    Hadith(
      narrator: "Mu’awiyah (رضي الله عنه)",
      text: "Calling the adhan is a source of immense reward.",
      reference: "Sahih Muslim 387",
    ),
    Hadith(
      narrator: "Abu Mahdhurah (رضي الله عنه)",
      text: "The Prophet taught us the adhan and iqamah.",
      reference: "Sahih Muslim 378",
    ),
    Hadith(
      narrator: "Ibn Abbas (رضي الله عنه)",
      text: "There is no prayer for the one who does not recite Al-Fatihah.",
      reference: "Sahih Bukhari 756",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "When prayer time enters, call the adhan even if alone.",
      reference: "Sahih al-Bayhaqi",
    ),
    Hadith(
      narrator: "Uthman (رضي الله عنه)",
      text: "Completing wudu wipes away sins from limbs.",
      reference: "Sahih Muslim 244",
    ),
    Hadith(
      narrator: "Abu Malik (رضي الله عنه)",
      text: "Purification is half of faith.",
      reference: "Sahih Muslim 223",
    ),
    Hadith(
      narrator: "Jabir (رضي الله عنه)",
      text:
          "Between every two adhans (adhan & iqamah) is a dua that is not rejected.",
      reference: "Sunan Abi Dawood 521",
    ),
    Hadith(
      narrator: "Anas (رضي الله عنه)",
      text: "The Prophet used to enter the masjid with his right foot.",
      reference: "Sunan Ibn Majah 748",
    ),
    Hadith(
      narrator: "Fatimah (رضي الله عنها)",
      text:
          "The Prophet taught: When entering masjid say, 'O Allah open for me the doors of Your mercy.’",
      reference: "Sahih Muslim 713",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "Saying Ameen with the angels leads to forgiveness of past sins.",
      reference: "Sahih Bukhari 782",
    ),
    Hadith(
      narrator: "Abdullah ibn Umar (رضي الله عنه)",
      text: "Do not raise your voices in the masjid.",
      reference: "Sahih Muslim 431",
    ),
    Hadith(
      narrator: "Abu Sa’id (رضي الله عنه)",
      text: "The Prophet forbade buying and selling inside the masjid.",
      reference: "Sunan At-Tirmidhi 1321",
    ),
    Hadith(
      narrator: "Anas (رضي الله عنه)",
      text: "Spitting in the masjid is a sin.",
      reference: "Sahih Muslim 552",
    ),
    Hadith(
      narrator: "Abu Hurairah (رضي الله عنه)",
      text: "Cleanliness of the masjid is charity.",
      reference: "Sunan Ibn Majah 759",
    ),
    Hadith(
      narrator: "Aisha (رضي الله عنها)",
      text: "The Prophet said: Allah loves gentleness in all matters.",
      reference: "Sahih Muslim 2593",
    ),
  ];


  //function to get a random hadith
  static Hadith getRandomHadith() {
    return _hadiths[Random().nextInt(_hadiths.length)];
  }
}
