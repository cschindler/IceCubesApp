import DesignSystem
import EmojiText
import Env
import Foundation
import Models
import Network
import SwiftUI

@MainActor
public struct ScheduledStatusRowView: View {
  @Environment(\.openWindow) private var openWindow
  @Environment(\.accessibilityVoiceOverEnabled) private var accessibilityVoiceOverEnabled
  @Environment(RouterPath.self) private var routerPath: RouterPath

  @Environment(QuickLook.self) private var quickLook
  @Environment(Theme.self) private var theme
  @Environment(Client.self) private var client

  @State private var viewModel: ScheduledStatusRowViewModel

  public init(viewModel: ScheduledStatusRowViewModel) {
    _viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: .statusComponentSpacing) {
//          Group {
//            StatusRowReplyView(viewModel: viewModel)
//          }
//          .padding(.leading, theme.avatarPosition == .top ? 0 : AvatarView.FrameConfig.status.width + .statusColumnsSpacing)

          HStack(alignment: .top, spacing: .statusColumnsSpacing) {
            AvatarView(viewModel.currentAccount.avatar)
              .accessibility(addTraits: .isButton)
              .contentShape(Circle())
              .hoverEffect()

            VStack(alignment: .leading, spacing: .statusComponentSpacing) {
              ScheduledStatusRowHeaderView(account: viewModel.currentAccount, scheduledStatus: viewModel.scheduledStatus)
              //StatusRowContentView(viewModel: viewModel)
              //  .contentShape(Rectangle())
              ScheduledStatusRowTextView(scheduledStatus: viewModel.scheduledStatus)
                .contentShape(Rectangle())
            }
          }
      }
      .padding(.init(top: 12, leading: 0, bottom: 6, trailing: 0))
    }
    .onAppear {
//      Task {
//        await viewModel.loadEmbeddedStatus()
//      }
    }
    .contextMenu {
      /// draft
    }
    .swipeActions(edge: .trailing) {
      Button("Annuler", systemImage: "clock.badge.xmark") {

      }
      .tint(.red)
    }
    .listRowInsets(.init(top: 0,
                         leading: .layoutPadding,
                         bottom: 0,
                         trailing: .layoutPadding))
    .alignmentGuide(.listRowSeparatorLeading) { _ in
      -100
    }
  }
}


@MainActor
struct ScheduledStatusRowHeaderView: View {
  @Environment(\.redactionReasons) private var redactionReasons
  @Environment(Theme.self) private var theme

  let account: Account
  let scheduledStatus: ScheduledStatus

  var body: some View {
    HStack(alignment: theme.avatarPosition == .top ? .center : .top) {
      accountView
        .hoverEffect()
        .accessibilityAddTraits(.isButton)
      Spacer()
      if !redactionReasons.contains(.placeholder) {
        dateView
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(Text("\(account.safeDisplayName), \(scheduledStatus.scheduledAt.relativeFormatted)"))
  }

  @ViewBuilder
  private var accountView: some View {
    HStack(alignment: .center) {
      if theme.avatarPosition == .top {
        AvatarView(account.avatar)
        #if targetEnvironment(macCatalyst)
          .accountPopover(account)
        #endif
      }
      VStack(alignment: .leading, spacing: 2) {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
          Group {
            EmojiTextApp(account.cachedDisplayName,
                         emojis: account.emojis)
              .fixedSize(horizontal: false, vertical: true)
              .font(.scaledSubheadline)
              .foregroundColor(theme.labelColor)
              .emojiText.size(Font.scaledSubheadlineFont.emojiSize)
              .emojiText.baselineOffset(Font.scaledSubheadlineFont.emojiBaselineOffset)
              .fontWeight(.semibold)
              .lineLimit(1)
            #if targetEnvironment(macCatalyst)
              .accountPopover(account)
            #endif
          }
          .layoutPriority(1)
        }
        if !redactionReasons.contains(.placeholder) {
          if (theme.displayFullUsername && theme.avatarPosition == .leading) ||
            theme.avatarPosition == .top
          {
            Text("@\(theme.displayFullUsername ? account.acct : account.username)")
              .fixedSize(horizontal: false, vertical: true)
              .font(.scaledFootnote)
              .foregroundStyle(.secondary)
              .lineLimit(1)
            #if targetEnvironment(macCatalyst)
              .accountPopover(viewModel.finalStatus.account)
            #endif
          }
        }
      }
    }
  }

  private var dateView: some View {
    let scheduledAtRelativeFormatter = RelativeDateTimeFormatter()
    scheduledAtRelativeFormatter.unitsStyle = .full
    scheduledAtRelativeFormatter.formattingContext = .listItem
    scheduledAtRelativeFormatter.dateTimeStyle = .numeric

    let date = scheduledAtRelativeFormatter.localizedString(
      for: scheduledStatus.scheduledAt.asDate,
      relativeTo: Date()
    )

    return Text("\(Image(systemName: scheduledStatus.params.visibility?.iconName ?? "tray.full")) ⸱ \(date)")
    .fixedSize(horizontal: false, vertical: true)
    .font(.scaledFootnote)
    .foregroundStyle(.secondary)
    .lineLimit(1)
  }
}

@MainActor
struct ScheduledStatusRowTextView: View {
  @Environment(Theme.self) private var theme

  var scheduledStatus: ScheduledStatus

  var body: some View {
    VStack {
      HStack {
        EmojiTextApp(HTMLString(stringValue: scheduledStatus.params.text),
                     emojis: [],
                     language: scheduledStatus.params.language)
          .fixedSize(horizontal: false, vertical: true)
          .font(.scaledBody)
          .lineSpacing(CGFloat(theme.lineSpacing))
          .foregroundColor(theme.labelColor)
          .emojiText.size(Font.scaledBodyFont.emojiSize)
          .emojiText.baselineOffset(Font.scaledBodyFont.emojiBaselineOffset)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

