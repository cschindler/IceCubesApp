import Foundation
import Models

public enum ScheduledStatuses: Endpoint {
  case scheduledStatuses(sinceId: String?)

  public func path() -> String {
    switch self {
    case .scheduledStatuses:
      "scheduled_statuses"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    case let .scheduledStatuses(sinceId):
      guard let sinceId else { return nil }
      return [.init(name: "max_id", value: sinceId)]
    }
  }
}

