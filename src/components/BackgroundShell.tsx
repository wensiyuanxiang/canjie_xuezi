import type { PropsWithChildren, ReactNode } from "react";

import { backgroundAssets, getAssetLabel } from "../config/assets";

type BackgroundVariant = keyof typeof backgroundAssets;

interface BackgroundShellProps {
  variant: BackgroundVariant;
  title: string;
  subtitle?: string;
  badge?: string;
  headerActions?: ReactNode;
  footer?: ReactNode;
  className?: string;
  contentClassName?: string;
  hideHeader?: boolean;
  hideFooter?: boolean;
  showAssetLabel?: boolean;
}

export function BackgroundShell({
  variant,
  title,
  subtitle,
  badge,
  headerActions,
  footer,
  className,
  contentClassName,
  hideHeader = false,
  hideFooter = false,
  showAssetLabel = false,
  children,
}: PropsWithChildren<BackgroundShellProps>) {
  const asset = backgroundAssets[variant];

  return (
    <section className={["screen-shell", asset.fallbackClassName, className ?? ""].filter(Boolean).join(" ")}>
      <div className="screen-shell__grain" />
      {!hideHeader ? (
        <header className="screen-shell__header">
          <div>
            {badge ? <p className="screen-shell__badge">{badge}</p> : null}
            <h1>{title}</h1>
            {subtitle ? <p className="screen-shell__subtitle">{subtitle}</p> : null}
          </div>
          {headerActions}
        </header>
      ) : null}
      <main className={["screen-shell__content", contentClassName ?? ""].filter(Boolean).join(" ")}>
        {children}
      </main>
      {!hideFooter ? (
        <footer className="screen-shell__footer">
          {showAssetLabel ? <span>{getAssetLabel(asset)}</span> : <span />}
          {footer}
        </footer>
      ) : null}
    </section>
  );
}
