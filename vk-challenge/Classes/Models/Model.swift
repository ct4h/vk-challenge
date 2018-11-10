//
//  Model.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation

struct Post: Decodable {

    let date: Int

//    let post_id: Int

    let text: String?

    let likes: Likes
    let comments: Comments
    let reposts: Reposts
    let views: Views

//    "comments": {
//    "count": 1,
//    "can_post": 1,
//    "groups_can_post": true
//    },
//    "likes": {
//    "count": 4,
//    "user_likes": 0,
//    "can_like": 1,
//    "can_publish": 1
//    },
//    "reposts": {
//    "count": 0,
//    "user_reposted": 0
//    },
//    "views": {
//    "count": 1217
//    }

}

struct Likes: Decodable {
    let count: Int
    let user_likes: Bool

//    "count": 4,
//    "user_likes": 0,
//    "can_like": 1,
//    "can_publish": 1
}

struct Comments: Decodable {
    let count: Int
//    "count": 1,
//    "can_post": 1,
//    "groups_can_post": true
}

struct Reposts: Decodable {
    let count: Int
    let user_reposted: Bool
}

struct Views: Decodable {
    let count: Int
}

struct NewsFeedResponse: Decodable {
    let items: [Post]
}


//"reposts": {
//    "count": 0,
//    "user_reposted": 0
//},
//"views": {
//    "count": 1217
//}

/*
{
    "response": {
        "items": [{
        "type": "post",
        "source_id": -68559738,
        "date": 1541853833,
        "post_id": 1112993,
        "post_type": "post",
        "text": "#matches@dotatoday

        The Kuala Lumpur Major, Группа Д, GSL, Нижняя сетка, Раунд 2

        Fnatic [1:0] Tigers [bo3]

        Game 2

        Stream:

        RU:twitch.tv/dota2mc_ru2
        EN:twitch.tv/pgl_Dota2En2

        Смотри игры и получай бонусы от Париматч http://bet4.pm/T21b",
        "marked_as_ads": 0,
        "attachments": [{
        "type": "photo",
        "photo": {
        "id": 456288126,
        "album_id": -7,
        "owner_id": -68559738,
        "user_id": 100,
        "sizes": [{
        "type": "m",
        "url": "https://sun1-4.us...948/op7R12UB1WM.jpg",
        "width": 130,
        "height": 87
        }, {
        "type": "o",
        "url": "https://sun1-15.u...94c/N6HpUYqoSds.jpg",
        "width": 130,
        "height": 87
        }, {
        "type": "p",
        "url": "https://sun1-11.u...94d/Q6UTHXIKy30.jpg",
        "width": 200,
        "height": 133
        }, {
        "type": "q",
        "url": "https://sun1-1.us...94e/CMalwJiu1fQ.jpg",
        "width": 320,
        "height": 213
        }, {
        "type": "r",
        "url": "https://sun1-16.u...94f/yhLrQGKMJbA.jpg",
        "width": 510,
        "height": 340
        }, {
        "type": "s",
        "url": "https://sun1-12.u...947/KrqQTBch8g4.jpg",
        "width": 75,
        "height": 50
        }, {
        "type": "x",
        "url": "https://sun1-4.us...949/8Qy4iW-8_cM.jpg",
        "width": 604,
        "height": 403
        }, {
        "type": "y",
        "url": "https://sun1-3.us...94a/-O-vbOru0J0.jpg",
        "width": 807,
        "height": 538
        }, {
        "type": "z",
        "url": "https://sun1-18.u...94b/0Pn1LJzsxwk.jpg",
        "width": 1230,
        "height": 820
        }],
        "text": "",
        "date": 1541853832,
        "post_id": 1112993,
        "access_key": "cbff9b22ae31e3930d"
        }
        }],
        "post_source": {
        "type": "api"
        },
        "comments": {
        "count": 1,
        "can_post": 1,
        "groups_can_post": true
        },
        "likes": {
        "count": 4,
        "user_likes": 0,
        "can_like": 1,
        "can_publish": 1
        },
        "reposts": {
        "count": 0,
        "user_reposted": 0
        },
        "views": {
        "count": 1217
        }
        }],
        "profiles": [],
        "groups": [{
        "id": 68559738,
        "name": "The Kuala Lumpur Major",
        "screen_name": "dotatoday",
        "is_closed": 0,
        "type": "page",
        "is_admin": 0,
        "is_member": 1,
        "photo_50": "https://pp.userap...rN4dOw_p4.jpg?ava=1",
        "photo_100": "https://pp.userap...ROFJbFPzs.jpg?ava=1",
        "photo_200": "https://pp.userap...Tftn6mYBk.jpg?ava=1"
        }, {
        "id": 22798006,
        "name": "Киномания",
        "screen_name": "kino_mania",
        "is_closed": 0,
        "type": "page",
        "is_admin": 0,
        "is_member": 1,
        "photo_50": "https://sun1-9.us...WYttZvShA.jpg?ava=1",
        "photo_100": "https://sun1-13.u...JIVApFECg.jpg?ava=1",
        "photo_200": "https://sun1-16.u...ByW0vdnAM.jpg?ava=1"
        }, {
        "id": 36541347,
        "name": "Gambit Esports",
        "screen_name": "gambitesports",
        "is_closed": 0,
        "type": "page",
        "is_admin": 0,
        "is_member": 0,
        "photo_50": "https://pp.userap...S6RHcPCDw.jpg?ava=1",
        "photo_100": "https://pp.userap...Us82Tjwkw.jpg?ava=1",
        "photo_200": "https://pp.userap...coTI8Zts8.jpg?ava=1"
        }],
        "next_from": "1/5_-68559738_1112993:1962826894"
    }
}

 "profiles": [],
 "groups": [{
 "id": 68559738,
 "name": "The Kuala Lumpur Major",
 "screen_name": "dotatoday",
 "is_closed": 0,
 "type": "page",
 "is_admin": 0,
 "is_member": 1,
 "photo_50": "https://pp.userap...rN4dOw_p4.jpg?ava=1",
 "photo_100": "https://pp.userap...ROFJbFPzs.jpg?ava=1",
 "photo_200": "https://pp.userap...Tftn6mYBk.jpg?ava=1"
 }, {
 "id": 30602036,
 "name": "IGM",
 "screen_name": "igm",
 "is_closed": 0,
 "type": "page",
 "is_admin": 0,
 "is_member": 1,
 "photo_50": "https://pp.userap...pQesqJois.jpg?ava=1",
 "photo_100": "https://pp.userap...curW0iS0U.jpg?ava=1",
 "photo_200": "https://pp.userap...ySDCssCms.jpg?ava=1"
 }, {
 "id": 36541347,
 "name": "Gambit Esports",
 "screen_name": "gambitesports",
 "is_closed": 0,
 "type": "page",
 "is_admin": 0,
 "is_member": 0,
 "photo_50": "https://pp.userap...S6RHcPCDw.jpg?ava=1",
 "photo_100": "https://pp.userap...Us82Tjwkw.jpg?ava=1",
 "photo_200": "https://pp.userap...coTI8Zts8.jpg?ava=1"
 }],
 "next_from": "1/5_-68559738_1113002:499268944"
*/
