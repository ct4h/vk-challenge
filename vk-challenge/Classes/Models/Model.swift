//
//  Model.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation

struct Post: Decodable {

    let source_id: Int
    let date: Int

    let text: String?

    let likes: Likes?
    let comments: Comments?
    let reposts: Reposts?
    let views: Views?
    let attachments: [Attachment]?
}

struct Likes: Decodable {
    let count: Int
}

struct Comments: Decodable {
    let count: Int
}

struct Reposts: Decodable {
    let count: Int
    let user_reposted: Int
}

struct Views: Decodable {
    let count: Int
}

struct Attachment: Decodable {
    let type: AttachmentType
    let photo: Photo?
}

enum AttachmentType: String, Decodable {
    case photo
    case other

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string == "photo" {
            self = .photo
        } else {
            self = .other
        }
    }
}

struct Photo: Decodable {
    let sizes: [AttachmentSize]
}

struct AttachmentSize: Decodable {
    let url: String
    let width: Int
    let height: Int
}

protocol PostOwner {
    var id: Int { get }
    var name: String { get }
    var photo_100: String? { get }
}

struct Profile: Decodable, PostOwner {
    let id: Int
    let first_name: String
    let last_name: String?
    let photo_100: String?

    var name: String {
        return first_name + " " + (last_name ?? "")
    }
}

struct Group: Decodable, PostOwner{
    let id: Int
    let name: String
    let photo_100: String?
}

struct NewsFeedResponse: Decodable {
    let items: [Post]
    let groups: [Group]
    let profiles: [Profile]
    let next_from: String?
}
