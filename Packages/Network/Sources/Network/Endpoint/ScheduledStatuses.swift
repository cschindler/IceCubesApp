import Foundation
import Models

public enum ScheduledStatuses: Endpoint {
  case scheduledStatuses(sinceId: String?)
  case cancel(id: String)
  case updateScheduledDate(id: String, scheduledAt: ServerDate)

  public func path() -> String {
    switch self {
    case .scheduledStatuses:
      "scheduled_statuses"
    case let .cancel(id):
      "scheduled_statuses/\(id)"
    case let .updateScheduledDate(id, _):
      "scheduled_statuses/\(id)"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    case let .scheduledStatuses(sinceId):
      guard let sinceId else { return nil }
      return [.init(name: "max_id", value: sinceId)]
    case .cancel:
      return nil
    case let .updateScheduledDate(_, scheduledAt):
      return [.init(name: "scheduled_at", value: scheduledAt.asDate.ISO8601Format())]
    }
  }
}

