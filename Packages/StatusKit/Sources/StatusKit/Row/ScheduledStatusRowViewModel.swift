import Combine
import DesignSystem
import Env
import Models
import NaturalLanguage
import Network
import Observation
import SwiftUI

@MainActor
@Observable public class ScheduledStatusRowViewModel {
  let scheduledStatus: ScheduledStatus

  let currentAccount: Account

  let client: Client

  public init(scheduledStatus: ScheduledStatus,
              currentAccount: Account,
              client: Client)
  {
    self.scheduledStatus = scheduledStatus
    self.currentAccount = currentAccount
    self.client = client
  }

  func cancel() async {
    do {
      _ = try await client.delete(endpoint: ScheduledStatuses.cancel(id: scheduledStatus.id))
    } catch {}
  }
}
