import type { PropsWithChildren, ReactNode } from "react";

interface PanelProps {
  title?: string;
  extra?: ReactNode;
  className?: string;
}

export function Panel({
  title,
  extra,
  className,
  children,
}: PropsWithChildren<PanelProps>) {
  return (
    <section className={["paper-panel", className ?? ""].filter(Boolean).join(" ")}>
      {title || extra ? (
        <header className="paper-panel__header">
          {title ? <h2>{title}</h2> : <span />}
          {extra}
        </header>
      ) : null}
      {children}
    </section>
  );
}
