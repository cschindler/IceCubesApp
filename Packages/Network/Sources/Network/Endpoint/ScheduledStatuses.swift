import Foundation
import Models

public enum ScheduledStatuses: Endpoint {
  case scheduledStatuses(sinceId: String?)
  case cancel(id: String)

  public func path() -> String {
    switch self {
    case .scheduledStatuses:
      "scheduled_statuses"
    case let .cancel(id):
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
    }
  }
}

