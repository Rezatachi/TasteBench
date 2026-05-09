import SwiftUI

struct SettingsView: View {
    private enum AppearancePreference: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        var id: String { rawValue }
    }

    @State private var appearance: AppearancePreference = .system
    @State private var allowsReflections = true

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: MiraSpacing.xl) {
                header
                profileRow
                preferencesSection
                privacySection
                signOutButton
            }
            .padding(MiraSpacing.lg)
        }
        .background(MiraColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(MiraTypography.caption)
                    .foregroundStyle(MiraColors.textSecondary)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.sm) {
            Text("A quieter Mira")
                .font(MiraTypography.title)
                .foregroundStyle(MiraColors.textPrimary)
            Text("Small preferences for how reflection fits into your day.")
                .font(MiraTypography.bodySans)
                .foregroundStyle(MiraColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var profileRow: some View {
        HStack(spacing: MiraSpacing.md) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(MiraColors.accent)
                .frame(width: 46, height: 46)
                .background(MiraColors.accent.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: MiraSpacing.xs) {
                Text("Personal journal")
                    .font(MiraTypography.heading)
                    .foregroundStyle(MiraColors.textPrimary)
                Text("Reflection space")
                    .font(MiraTypography.caption)
                    .foregroundStyle(MiraColors.textSecondary)
            }

            Spacer()
        }
        .padding(MiraSpacing.lg)
        .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.5)
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.md) {
            SectionHeader(eyebrow: "Preferences", title: "How Mira feels")

            VStack(spacing: 0) {
                settingsRow(title: "Appearance", subtitle: "Follow your preferred reading light") {
                    Picker("Appearance", selection: $appearance) {
                        ForEach(AppearancePreference.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(MiraColors.accent)
                }

                divider

                settingsRow(title: "Notifications", subtitle: "A gentle reflection reminder") {
                    Toggle("Notifications", isOn: $allowsReflections)
                        .labelsHidden()
                        .tint(MiraColors.accent)
                }
            }
            .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.5)
        }
    }

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.md) {
            SectionHeader(eyebrow: "Privacy", title: "Your entries stay close")

            VStack(alignment: .leading, spacing: 0) {
                privacyRow(
                    systemImage: "lock",
                    title: "On-device journal",
                    subtitle: "This prototype keeps reflections local to the app."
                )

                divider

                privacyRow(
                    systemImage: "hand.raised",
                    title: "No account required",
                    subtitle: "Mira does not add sign-in or cloud sync here."
                )
            }
            .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.5)
        }
    }

    private var signOutButton: some View {
        Button {} label: {
            Text("Sign out")
                .font(MiraTypography.caption)
                .foregroundStyle(MiraColors.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .miraSurface(cornerRadius: MiraRadius.md, borderOpacity: 0.5)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Account actions are not enabled in this version of Mira")
    }

    private var divider: some View {
        Rectangle()
            .fill(MiraColors.border.opacity(0.6))
            .frame(height: 1)
            .padding(.leading, MiraSpacing.lg)
    }

    private func settingsRow<Accessory: View>(
        title: String,
        subtitle: String,
        @ViewBuilder accessory: () -> Accessory
    ) -> some View {
        HStack(spacing: MiraSpacing.md) {
            VStack(alignment: .leading, spacing: MiraSpacing.xs) {
                Text(title)
                    .font(MiraTypography.bodySans.weight(.semibold))
                    .foregroundStyle(MiraColors.textPrimary)
                Text(subtitle)
                    .font(MiraTypography.caption)
                    .foregroundStyle(MiraColors.textSecondary)
            }

            Spacer(minLength: MiraSpacing.md)

            accessory()
        }
        .padding(MiraSpacing.lg)
    }

    private func privacyRow(systemImage: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: MiraSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(MiraColors.accent)
                .frame(width: 28, height: 28)
                .background(MiraColors.accent.opacity(0.10), in: Circle())

            VStack(alignment: .leading, spacing: MiraSpacing.xs) {
                Text(title)
                    .font(MiraTypography.bodySans.weight(.semibold))
                    .foregroundStyle(MiraColors.textPrimary)
                Text(subtitle)
                    .font(MiraTypography.caption)
                    .foregroundStyle(MiraColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(MiraSpacing.lg)
    }
}
