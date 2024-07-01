import Foundation

public protocol AnyScheduledStatus {
  var id: String { get }
  var scheduledAt: ServerDate { get }
  var params: ScheduledParams { get }
  var mediaAttachments: [MediaAttachment] { get }
}

public final class ScheduledStatus: AnyScheduledStatus, Codable, Identifiable, Equatable, Hashable {
  public static func == (lhs: ScheduledStatus, rhs: ScheduledStatus) -> Bool {
    lhs.id == rhs.id &&
    lhs.scheduledAt.asDate == rhs.scheduledAt.asDate &&
    lhs.params == rhs.params
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public let id: String
  public let scheduledAt: ServerDate
  public let params: ScheduledParams
  public let mediaAttachments: [MediaAttachment]
}

public struct ScheduledParams: Codable, Equatable {
  public let text: String
  public let mediaIds: [String]?
  public let inReplyToId: Int?
  public let sensitive: Bool?
  public let spoilerText: String?
  public let visibility: Visibility?
  public let language: String?
  public let scheduledAt: ServerDate?
  public let idempotency: String?
  public let withRateLimit: Bool?
  public let poll: Poll?
  public let applicationId: Int?
}

extension ScheduledStatus: Sendable {}

extension ScheduledParams: Sendable {}
